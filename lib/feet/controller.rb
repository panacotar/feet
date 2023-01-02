require 'erubis'
require 'rack/request'
require 'feet/file_model'
require 'feet/view'

module Feet
  class Controller
    include Feet::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def params
      request.params.merge @routing_params
    end

    def build_response(text, status = 200, headers = {})
      raise "Already responded!" if @response

      a = text
      @response = Rack::Response.new(a, status, headers)
    end

    def response
      @response
    end

    def render_response(*args)
      build_response(render(*args))
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

    def instance_hash
      instance_variables.each_with_object(Hash.new('')) do |iv, hash|
        hash[iv] = instance_variable_get iv
      end
    end

    def render(view_name)
      filename = File.join 'app', 'views', controller_name, "#{view_name}.html.erb"
      template = File.read filename
      View.new(template, instance_hash).call
    end

    def self.action(act, route_params = {})
      proc { |e| self.new(e).dispatch(act, route_params) }
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params

      text = send(action)
      if response
        [response.status, response.headers, [response.body].flatten]
      else
        [200, { 'Content-Type' => 'text/html' }, [text]]
      end

    end
  end
end
