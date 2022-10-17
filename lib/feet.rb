# frozen_string_literal: true

require_relative "feet/version"
require 'feet/array'

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      `echo #{env} > debug.txt`;
      [200, {'Content-Type' => 'text/json'},
        ["Hello from Ruby on Feet!"]]
    end
  end
end
