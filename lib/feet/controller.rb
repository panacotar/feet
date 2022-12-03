require 'erubis'
require 'feet/file_model'

module Feet
  class Controller
    include Feet::Model

    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def class_name
      self.class
    end

    def feet_version
      Feet::VERSION
    end

    def controller_name
      # self.class.to_s.split('Controller').first.downcase
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')
      Feet.to_snake_case klass
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views', controller_name, "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(
        env: env,
        controller_name: controller_name,
        class_name: class_name,
        feet_version: feet_version
      )
    end
  end
end
