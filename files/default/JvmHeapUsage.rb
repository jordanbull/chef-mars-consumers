module God
	module Conditions

		# Condition Symbol :jvm_heap_usage
		# Type: Poll
		#
		# Trigger when the percent of jvm heap use of a process is above a specified limit.
		#
		# Paramaters
		#   Required
		#     +pid_file+ is the pid file of the process in question. Automatically
		#                populated for Watches.
		#     +above+ is the percent CPU above which to trigger the condition. You
		#             may use #percent to clarify this amount (see examples).
		#
		# Examples
		#
		# Trigger if the process is using more than 80 percent of the jvm heap (from a Watch):
		#
		#   on.condition(:jvm_heap_usage) do |c|
		#     c.above = 80.percent
		#   end
		#
		# Non-Watch Tasks must specify a PID file:
		#
		#   on.condition(:jvm_heap_usage) do |c|
		#     c.above = 80.percent
		#     c.pid_file = "/var/run/mongrel.3000.pid"
		#   end
		class JvmHeapUsage < PollCondition
			attr_accessor :above, :times, :pid_file

			def initialize
				super
				self.above = nil
				self.times = [1, 1]
			end

			def prepare
				if self.times.kind_of?(Integer)
					self.times = [self.times, self.times]
				end

				@timeline = Timeline.new(self.times[1])
			end

			def reset
				@timeline.clear
			end

			def pid
				self.pid_file ? File.read(self.pid_file).strip.to_i : self.watch.pid
			end

			def jetty_pid
				# Get the child pids.
				jetty_ps_cmd = "ps aux | grep jetty | grep -v daemon | grep -v grep | awk '{print $2}'"
				jetty_pid = IO.popen(jetty_ps_cmd) do |jetty|
					jetty.readlines.map do |line|
						parts = line.split(/\s+/)
						parts[0]
					end.compact
				end

				# Show the child processes.
				jetty_pid.size == 0 ? nil : jetty_pid[0]
			end

			def jvm_heap_usage(pid)
				heapUsage = nil
				# for the following, keep in mind that S0 and S1 (survivor 0 & 1) will rotate roles after each garbage collection
				# we only one will be in effect when calculating for heap usage and max cap

				# find out heap usage, will look like the following
				# C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT
				# 192.0  192.0   0.0    0.0    2048.0   1244.0    4864.0      0.0     21248.0 2908.3      0    0.000   0      0.000    0.000
				# we care about S0U/S1U (survivor space) & EU (eden space) & OU (old space)
				IO.popen("jstat -gc #{pid}") do |jstat|
					results = jstat.readlines
					if results.size > 0
						headers = results[0].strip.split(/\s+/)
						heapUsage = results[1].strip.split(/\s+/).each_with_index.map {|value, i|
							["S0U", "S1U", "EU", "OU"].include?(headers[i]) ? value.to_f : nil
						}.compact.inject{|sum, x| sum + x}
					end
				end

				return heapUsage
			end

			def jvm_new_gen_max(pid)
				newGenCap = nil
				# find out new gen max capacity (eden + survivor), will look like the following
				# NGCMN      NGCMX       NGC      S0CMX     S0C     S1CMX     S1C       ECMX        EC      YGC   FGC
				# 2432.0    43008.0     2432.0   4288.0    192.0   4288.0    192.0    34432.0     2048.0     0     0
				# we care about S0CMX/S1CMX (max survivor space capacity) & ECMX (max eden space capcity)
				IO.popen("jstat -gcnewcapacity #{pid}") do |jstat|
					results = jstat.readlines
					if results.size > 0
						headers = results[0].strip.split(/\s+/)
						newGenCap = results[1].strip.split(/\s+/).each_with_index.map {|value, i|
							["S0CMX", "ECMX"].include?(headers[i]) ? value.to_f : nil
						}.compact.inject{|sum, x| sum + x}
					end
				end

				return newGenCap
			end

			def jvm_old_gen_max(pid)
				oldGenCap = nil
				#find out old gen max capacity, will look like the following
				# OGCMN       OGCMX        OGC         OC       YGC   FGC    FGCT     GCT
				# 4864.0     86016.0      4864.0      4864.0     0     0    0.000    0.000
				# we care about OGCMX (max old generation capacity)
				IO.popen("jstat -gcoldcapacity #{pid}") do |jstat|
					results = jstat.readlines
					if results.size > 0
						headers = results[0].strip.split(/\s+/)
						oldGenCap = results[1].strip.split(/\s+/).each_with_index.map {|value, i|
							["OGCMX"].include?(headers[i]) ? value.to_f : nil
						}.compact.inject{|sum, x| sum + x}
					end
				end

				return oldGenCap
			end
				
			def jvm_heap_usage_percentage(pid)
				if pid == nil
					puts "jetty pid is nil"
					return 0.percent
				end

				heapUsage = self.jvm_heap_usage(pid)
				if heapUsage == nil
					puts "jvm heap usage for pid #{pid} is unavailable"
					return 0.percent
				else
					puts "jvm heap usage: #{heapUsage} KB"
				end

				oldGenCap = self.jvm_old_gen_max(pid)
				if oldGenCap == nil
					puts "old generation max capacity for pid #{pid} is unavailable"
					return 0.percent
				else
					puts "old generation max capacity: #{oldGenCap} KB"
				end

				newGenCap = self.jvm_new_gen_max(pid)
				if newGenCap == nil
					puts "new generation max capacity for pid #{pid} is unavailable"
					return 0.percent
				else
					puts "new generation max capacity: #{newGenCap} KB"
				end

				jvmHeapUsagePercentage = (heapUsage / (newGenCap + oldGenCap) * 100).percent
				puts "jvm heap usage percentage: #{jvmHeapUsagePercentage}%"
				return jvmHeapUsagePercentage
			end

			def valid?
				valid = true
				valid &= complain("Attribute 'pid_file' must be specified", self) if self.pid_file.nil? && self.watch.pid_file.nil?
				valid &= complain("Attribute 'above' must be specified", self) if self.above.nil?
				valid
			end

			def test
				@timeline.push(self.jvm_heap_usage_percentage(self.jetty_pid))
				self.info = []

				history = "[" + @timeline.map { |x| "#{x > self.above ? '*' : ''}#{x}%%" }.join(", ") + "]"

				if @timeline.select { |x| x > self.above }.size >= self.times.first
					self.info = "jvm heap usage out of bounds #{history}"
					return true
				else
					return false
				end
			end
		end

	end
end
