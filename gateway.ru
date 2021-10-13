require 'rack-proxy'

APP_PREFIX = '/gateway/my-app'
class Gateway < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)

    if request.path.start_with?(APP_PREFIX)
      env['HTTP_X_FORWARDED_HOST'] = env['SERVER_NAME']
      env['HTTP_X_FORWARDED_PROTO'] = env['rack.url_scheme']

      # DO NOT remove the prefix from the path
      # env['PATH_INFO'] = env['PATH_INFO'].delete_prefix(APP_PREFIX).gsub(%r'^$', '/')

      env["HTTP_HOST"] = 'localhost:5100'

      super(env)
    else
      [200, {}, ['This request did not go to the proxied rails app']]
    end
  end
end

run Gateway.new(backend: 'http://localhost:5100')
