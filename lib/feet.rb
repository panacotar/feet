# frozen_string_literal: true

require_relative "feet/version"
require 'feet/array'
require 'feet/routing'
require 'feet/dependencies'
require 'feet/controller'

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      if env["PATH_INFO"] == "/default"
        path = File.expand_path('../public/index.html', __dir__)
        return [200, {"Content-Type" => "text/html"}, File.open(path)]
      end

      if env["PATH_INFO"] == "/redirect"
        # Perform a redirect
        return [301, {'Location' => '/quotes/a_quote'}, []]
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)

      if post?(env)
        `echo "a new POST #{env['PATH_INFO']}" > debug.txt`;
      end

      begin
        text = controller.send(action)
      rescue
        text = "<p style='color:red;'>Something went wrong</p>"
      end

      [200, {'Content-Type' => 'text/html'},
        [text]]
    end
  end
end
