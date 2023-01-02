module Feet
  class RouteObject
    def initialize
      @rules = []
    end

    # Example arguments
    # url  ":controller/:id"
    # args [{:default=>{"action"=>"show"}}]
    def match(url, *args)
      # Capture the options hash
      options = {}
      options = args.pop if args[-1].is_a? Hash
      # Check for default option
      options[:default] ||= {}

      # Get destination and limit the # of arguments
      dest = nil
      dest = args.pop if args.size > 0
      raise 'Too many arguments!' if args.size > 0

      # Parse URL parts
      parts = url.split('/')
      # parts.select! { |p| !p.empty? }
      parts.reject! { |p| p.empty? }

      vars = []
      regexp_parts = parts.map do |part|
        case part[0]
        when ':'
          # Map Variable
          vars << part[1..-1]
          '([a-zA-Z0-9]+)'
        when '*'
          # Map Wildcard
          vars << part[1..-1]
          '(.*)'
        else
          part
        end
      end

      regexp = regexp_parts.join('/')
      @rules.push({
                    regexp: Regexp.new("^/#{regexp}$"),
                    vars: vars,
                    dest: dest,
                    options: options
                  })
    end


  end

  class Application
    def get_controller_and_action(env)
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