module God
	module Conditions

		# Condition Symbol :service_jetty_availability
		# Type: Poll
		#
		# Trigger when the available.
		#
		# Paramaters
		#   Required
		#     +available+ is the service availability which to trigger the condition.
		#
		# Examples
		#
		# Trigger if the process is using more than 80 percent of the jvm heap (from a Watch):
		#
		#   on.condition(:service_jetty_availability) do |c|
		#     c.available = false
		#   end
		#
		class ServiceJettyAvailability < PollCondition
			attr_accessor :available, :times, :pid_file

			def initialize
				super
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

			def pid_valid(pid)
				Integer(pid) != nil rescue false
			end

			def service_jetty_available
				if self.pid_valid(self.pid)
					puts "self.pid is available (#{self.pid})"
					return self.pid
				end

				# Get the child pids.
				jetty_ps_cmd = "ps aux | grep jetty | grep start.jar | grep -v grep | awk '{print $2}'"
				jetty_pid = IO.popen(jetty_ps_cmd) do |jetty|
					jetty.readlines.map do |line|
						parts = line.split(/\s+/)
						parts[0]
					end.compact
				end

				# Show the child processes.
				if (jetty_pid.size > 0)
					puts "jetty process (#{jetty_pid}) is available"
					return true
				else
					puts "jetty process not available"
					return false
				end
			end

			def valid?
				valid = true
				valid &= complain("Attribute 'pid_file' must be specified", self) if self.pid_file.nil? && self.watch.pid_file.nil?
				valid &= complain("Attribute 'available' must be specified", self) if self.available.nil?
				valid
			end

			def test
				serviceAvailable = self.service_jetty_available
				@timeline.push(serviceAvailable)
				self.info = []

				if @timeline.select { |x| x == self.available }.size >= self.times.first
					self.info = "service jetty availability #{history}"
					return true
				else
					return false
				end
			end
		end

	end
end
