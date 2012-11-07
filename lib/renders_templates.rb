require 'action_controller'
require 'active_support/dependencies'

module RendersTemplates
  require 'renders_templates/dummy_controller'

  def get_renderer
    @@controller ||= DummyController.new
  end

  def render_to_string(args=nil)
    get_renderer._render args
  end

  def head_assets
    @@head_assets ||= get_renderer._render partial: 'shared/head_assets'
  end

  def body_assets
    @@body_assets ||= get_renderer._render partial: 'shared/body_assets'
  end

  def add_body_class_to(html, classname)
    body_tag = html.scan(/\<body[^>]*\>/)[0]
    return html unless body_tag.present?
    if body_tag.include? 'class='
      html = html.sub(body_tag, body_tag.sub(/ class=\"([^\"]+)\"/, " class=\"#{$1} #{classname}\""))
    else
      html = html.sub(body_tag, body_tag.sub('body', "body class=\"#{classname}\""))
    end
  end

end
