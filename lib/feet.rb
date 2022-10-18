# frozen_string_literal: true

require_relative "feet/version"
require 'feet/array'
require 'feet/routing'

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      `echo "first #{env}" > debug.txt`;
      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(action)

      [200, {'Content-Type' => 'text/html'},
        [text]]
    end
  end
    end
  end
end
