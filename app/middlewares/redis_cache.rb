# **RedisCache** is a middleware that sits at the top of the Rails middleware
# stack. In other words, it's the first middleware to be hit. This is set in
# `config/application.rb`.

### The Middleware
class RedisCache

  # Instantiate a Rack `@app` and `@redis` client.
  def initialize(app, options={})
    @app = app
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
  end

  def call(env)
    # Grab the relative path from the request.
    path = Rack::Request.new(env).path
    # Is the path saved in Redis as a key?
    # If so, log the hit and serve the key's value immediately.
    if cached_content = @redis.get(path)
      Rails.logger.info "RedisCache hit for #{path} at #{Time.now}"
      [200, {'Content-Type'   => 'text/html',
             'Content-Length' => cached_content.length.to_s
            }, [cached_content]]
      # Otherwise, continue down the Rails middleware stack.
    else
      @app.call(env)
    end
  end

end
