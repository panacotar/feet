# frozen_string_literal: true

require_relative "feet/version"

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      `echo debug > debug.txt`;
      [200, {'Content-Type' => 'text/html'},
        ["Hello from Ruby on Feet!"]]
    end
  end
end
