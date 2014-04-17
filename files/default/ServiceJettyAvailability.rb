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

			def service_jetty_available
				# Get the child pids.
				pipe = IO.popen("ps ax | grep jetty | grep -v grep | grep -v daemon")

				jetty_pid = pipe.readlines.map do |line|
					parts = line.split(/\s+/)
					parts[0]
				end.compact

				# Show the child processes.
				jetty_pid.size > 0 ? true : false
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