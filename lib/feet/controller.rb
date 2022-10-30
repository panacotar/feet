module Feet
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def me
      self.class.to_s.split('Controller').first.downcase
    end

  end
end