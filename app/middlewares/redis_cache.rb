# **RedisCache** is a middleware that sits at the top of the Rails middleware
# stack. In other words, it's the first middleware to be hit. This is set in
# `config/application.rb`.

### The Middleware
class RedisCache

  # Instantiate a Rack `@app` and `@redis` client.
  def initialize(app, options={})
    @app = app
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => REDIS)
  end

  def call(env)
    # request = Rack::Request.new(env)
    request = ActionDispatch::Request.new(env)

    # Is the path saved in Redis as a key? Have we seen this user before?
    # If so, log the hit and serve the key's value immediately.
    if request.get? && cached_content = @redis.get(request.path)
      Rails.logger.info "RedisCache hit for #{request.path} at #{Time.now}"
      handle_cached_response(request, cached_content)
      # Otherwise, continue down the Rails middleware stack.
    else
      @app.call(env)
    end
  end

  protected

  # Wrap jsonp and serve as application/json where appropriate.
  def handle_cached_response(request, cached_content)
    mimetype = 'text/html'
    if request.path =~ /\.json$/
      if request.params.include? 'callback' and not request.params['callback'] =~ /\W/
        callback = request.params['callback']
        cached_content = "#{callback}(#{cached_content})"
      end
      mimetype = 'application/json'
    else
      # Insert csrf meta tags right before the head closes if this is an html request
      cached_content = cached_content.gsub('</head>', csrf_meta(request) + '</head>')
    end

    [200, {'Content-Type'   => mimetype,
           'Content-Length' => cached_content.length.to_s,
           'Cache-Control' => 'no-cache, max-age=0',
          }, [cached_content]]
  end

  def csrf_meta(request)
    <<-CSRF.strip_heredoc
    <meta content="authenticity_token" name="csrf-param" />
    <meta content="#{request.cookie_jar.signed["_datajam_session"]["_csrf_token"] rescue nil}" name="csrf-token" />
    CSRF
  end

end
