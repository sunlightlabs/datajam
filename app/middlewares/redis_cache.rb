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
    request = Rack::Request.new(env)
    # Is the path saved in Redis as a key?
    # If so, log the hit and serve the key's value immediately.
    if cached_content = @redis.get(request.path)
      Rails.logger.info "RedisCache hit for #{request.path} at #{Time.now}"
      handle_cached_response request, cached_content
      # Otherwise, continue down the Rails middleware stack.
    else
      @app.call(env)
    end
  end

  # Wrap jsonp and serve as application/json where appropriate.
  def handle_cached_response(request, cached_content)
    mimetype = 'text/html'
    if request.path =~ /\.json$/
      if request.params.include? 'callback' and not request.params['callback'] =~ /\W/
        callback = request.params['callback']
        cached_content = "#{callback}(#{cached_content})"
      end
      mimetype = 'application/json'
    end

    [200, {'Content-Type'   => mimetype,
           'Content-Length' => cached_content.length.to_s
          }, [cached_content]]
  end

end
