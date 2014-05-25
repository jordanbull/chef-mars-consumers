require "/opt/god/conditions/JvmHeapUsage.rb"
require "/opt/god/conditions/ServiceJettyAvailability.rb"

God.watch do |w|
	w.name = "tntNucleusService"
	w.start = ""
	w.stop = ""
	w.restart = "service jetty restart"
	w.pid_file = "/var/run/jetty.pid"	# this is the pid file for jetty started by upstart as a service

	w.behavior(:clean_pid_file)

	w.restart_if do |restart|
		restart.condition(:jvm_heap_usage) do |c|
			c.interval = 30.seconds
			c.above = 70.percent
			c.times = [4, 5] # 4 out of 5 intervals
		end

		restart.condition(:service_jetty_availability) do |c|
			c.interval = 1.minute
			c.available = false
			c.times = [3, 3] # 5 out of 5 intervals
		end
	end
end
