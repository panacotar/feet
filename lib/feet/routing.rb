module Feet
  class Application
    def get_controller_and_action(env)
      `echo #{env["PATH_INFO"]} >> debug.txt`
      _, cont, action, _after = env["PATH_INFO"].split('/', 4)
      action ||= 'index'
      cont = cont == '' ? 'Home' : cont.capitalize
      cont += "Controller"

      [Object.const_get(cont), action]
    end

    def post?(env)
      env['REQUEST_METHOD'] == 'POST'
    end
  end
end