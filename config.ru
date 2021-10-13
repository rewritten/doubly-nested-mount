# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

module Middleware
  class Logger
    def initialize(app, logger)
      @app = app
      @logger = logger
    end

    def call(env)

      headers = env.
                select { |k,v| k.start_with? 'HTTP_'}.
                transform_keys { |k| k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-') }.
                sort.to_h

      request_params = env['rack.input'].read

      @logger.info "Request: #{env["REQUEST_METHOD"]} #{env["PATH_INFO"]} #{headers} #{request_params}"

      @app.call(env)
    end
  end
end

use Middleware::Logger, Logger.new(STDOUT)

map Rails.application.config.relative_url_root || "/" do
  run Rails.application
end
# instead of:
# run Rails.application

Rails.application.load_server
