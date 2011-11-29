module Datajam
  module Settings

    def self.[](namespace)
      ns = namespace.to_sym
      @@settings ||= {}
      @@settings[ns] ||= {}
      unless @@settings[ns].any?
        settings = Setting.where(:namespace => namespace.to_s)
        settings.each do |setting|
          @@settings[ns][setting.name.to_sym] ||= setting.value
        end
      end
      @@settings[ns]
    end

    def self.get(key, options)
      @@settings ||= {}
      default = Proc.new { return options[:default] rescue nil }

      key = key.to_s
      unless options.is_a? Hash
        options = {:namespace => options.to_s}
      end
      default.call unless options.include?(:namespace)

      @@settings[options[:namespace].to_sym] ||= {}
      begin
        @@settings[options[:namespace].to_sym][key.to_sym] ||= Setting.where(:namespace => options[:namespace], :name => key).first.value
      rescue
        default.call
      end
    end

    def self.flush(namespace)
      begin
        @@settings[namespace.to_sym] = {}
      rescue
        return false
      end
      true
    end
  end

end