# frozen_string_literal: true

require_relative 'feet/version'
require 'feet/array'
require 'feet/routing'
require 'feet/dependencies'
require 'feet/controller'
require 'feet/utils'

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      return [404, { 'Content-Type' => 'text/html' }, []] if env['PATH_INFO'] == '/favicon.ico'

      if env['PATH_INFO'] == '/default'
        path = File.expand_path('../public/index.html', __dir__)
        return [200, { 'Content-Type' => 'text/html' }, File.open(path)]
      end

      if env['PATH_INFO'] == '/redirect'
        # Perform a redirect
        return [301, { 'Location' => '/quotes/a_quote' }, []]
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)

      `echo "a new POST #{env['PATH_INFO']}" > debug.txt` if post?(env)

      begin
        text = controller.send(action)
      rescue StandardError => e
        puts e
        text = "<h2>Something went wrong</h2>
                <pre style='color:red;'>#{e}</pre>"
      end

      resp = controller.response
      if resp
        [resp.status, resp.headers, [resp.body].flatten]
      else
        [200, { 'Content-Type' => 'text/html' }, [text]]
      end
    end
  end
end
