require "/opt/god/conditions/JvmHeapUsage.rb"

God.watch do |w|
	w.name = "tntNucleusService"
	w.start = ""
	w.stop = ""
	w.restart = "service jetty restart"
	w.pid_file = "/var/run/jetty.pid"	# this is the pid file for jetty started by upstart as a service

	w.behavior(:clean_pid_file)

	# determine the state on startup
	w.transition(:init, :up) do |on|
		on.condition(:process_running) do |c|
			c.interval = 1.day
			c.running = true
		end
	end

	# determin conditions for restart
	w.restart_if do |restart|
		restart.condition(:jvm_heap_usage) do |c|
			c.interval = 30.seconds
			c.above = 70.percent
			c.times = [4, 5] # 4 out of 5 intervals
		end

		restart.condition(:process_running) do |c|
			c.interval = 1.minute
			c.running = false
			c.times = [3, 3] # 3 out of 3 intervals
		end
	end

	# watch for service flapping
	w.lifecycle do |on|
		on.condition(:flapping) do |c|
			c.to_state = :restart
			c.times = 2
			c.within = 5.minutes
		end
	end
end
