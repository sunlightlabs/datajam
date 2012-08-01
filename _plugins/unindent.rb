module Jekyll
  module UnindentFilter
    def unindent input
      input.lstrip
    end
  end
end

Liquid::Template.register_filter Jekyll::UnindentFilter