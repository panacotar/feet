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

      # Join the main regexp
      regexp = regexp_parts.join('/')

      # Store match object
      @rules.push({
                    regexp: Regexp.new("^/#{regexp}$"),
                    vars: vars,
                    dest: dest,
                    options: options
                  })
    end

    def check_url(url)
      @rules.each do |rule|
        # Check if rule against regexp
        match_data = rule[:regexp].match(url)

        # Build params hash
        if match_data
          options = rule[:options]
          params = options[:default].dup
          # Match variable names with the regexp captured parts
          rule[:vars].each_with_index do |var, i|
            params[var] = m.captures[i]
          end
        end

        if rule[:dest]
          # There's a destination like 'controller#action'
          return get_dest(rule[:dest], params)
        else
          # Use controller#action to get the Rack application
          controller = params['controller']
          action = params['action']
          return get_dest("#{controller}##{action}", params)
        end
      end
      nil
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