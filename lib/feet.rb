# frozen_string_literal: true

require_relative "feet/version"
require 'feet/array'
require 'json'

module Feet
  class Error < StandardError; end

  class Application
    def call(env)
      body = {username: 'andrew', favorite_color: 'green'}.to_json
      `echo #{body} > debug.txt`;
      [200, {'Content-Type' => 'text/json'},
        ["#{body}"]]
    end
  end
end
