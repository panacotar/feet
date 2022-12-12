require 'erubis'

module Feet
  class View
    def initialize(template, instance_hash)
      @template = template
      init_vars(instance_hash)
    end

    def call
      eruby = Erubis::Eruby.new(@template)
      # Locals here are in addition to instance variables, if any
      eval eruby.src
    end

    def init_vars(received_vars)
      received_vars.each do |key, value|
        puts 'key'
        p key

        instance_variable_set(key, value)
      end
    end

    # Helper method for View
    def h(str)
      URI.escape str
    end
  end
end