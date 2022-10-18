module Feet
  class Application
    def get_controller_and_action(env)
      `echo #{env["PATH_INFO"]} >> debug.txt`
      _, cont, action, after = env["PATH_INFO"].split('/', 4)
      cont = cont.capitalize
      cont += "Controller"

      [Object.const_get(cont), action]
    end
  end
end