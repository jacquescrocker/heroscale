module Heroscale

  # simple Rack Middleware that adds a hook to return the heroku env info
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] == "/heroscale/status"
        queue_wait_time = env['HTTP_X_HEROKU_QUEUE_WAIT_TIME']
        queue_depth = env['HTTP_X_HEROKU_QUEUE_DEPTH']
        dynos_in_use = env['HTTP_X_HEROKU_DYNOS_IN_USE']
        job_queue = count_jobs || 0

        if queue_wait_time and queue_depth and dynos_in_use
          # format the response on heroku
          res = %|{"heroku": true, "queue_wait_time": #{queue_wait_time.to_i}, "queue_depth": #{queue_depth.to_i}, "dynos_in_use": #{dynos_in_use.to_i}, "job_queue": #{job_queue}}|
        else
          res = %|{"heroku": false}|
        end

        [ 200, {'Content-Type' => 'application/json'}, res]
      else
        @app.call(env)
      end
    end

    protected

    # count the pending jobs for Delayed::Job or Resque
    def count_jobs
      if defined?(Delayed::Job)
        Delayed::Job.count
      elsif defined?(Resque) and ENV["QUEUE"]
        Resque.size(ENV["QUEUE"])
      else
        0
      end
    rescue => e
      puts "Error counting jobs: #{e.to_s}"
      return 0
    end

  end
end