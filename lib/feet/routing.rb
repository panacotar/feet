module Feet
  class Application
    def get_controller_and_action(env)
      `echo #{env["PATH_INFO"]} >> debug.txt`
      action ||= 'index'
      cont += "Controller"

      [Object.const_get(cont), action]
    end

    def post?(env)
      env['REQUEST_METHOD'] == 'POST'
    end

  end
end