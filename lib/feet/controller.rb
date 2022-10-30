require 'erubis'

module Feet
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def me
      self.class.to_s.split('Controller').first.downcase
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views', me.to_s, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(:env => env)
    end
  end
end