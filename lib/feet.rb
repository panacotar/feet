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

      # Assign a default Feet HTML welcome page (in public/index.html)
      if env['PATH_INFO'] == '/feet'
        path = File.expand_path('../public/index.html', __dir__)
        return [200, { 'Content-Type' => 'text/html' }, File.open(path)]
      end

      # Perform a redirect
      return [301, { 'Location' => '/quotes/a_quote' }, []] if env['PATH_INFO'] == '/redirect'

      rack_app = get_rack_app(env)
      rack_app.call(env)
    end
  end
end
