require "/opt/god/conditions/JvmHeapUsage.rb"
require "/opt/god/conditions/ServiceJettyAvailability.rb"

God.watch do |w|
	w.name = "tntNucleusService"
	w.start = ""
	w.stop = ""
	w.restart = "service jetty restart"

	w.behavior(:clean_pid_file)

	w.restart_if do |restart|
		restart.condition(:jvm_heap_usage) do |c|
			c.interval = 5.minutes
			c.above = 80.percent
			c.times = [3, 5] # 3 out of 5 intervals
		end

		restart.condition(:service_jetty_availability) do |c|
			c.interval = 1.minute
			c.available = false
			c.times = [3, 3] # 5 out of 5 intervals
		end
	end
end