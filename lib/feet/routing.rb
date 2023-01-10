module Feet
  class RouteObject
    def initialize
      @rules = []
      @default_rules = [
        {
          regexp: /^\/([a-zA-Z0-9]+)$/,
          vars: ["controller"],
          dest: nil,
          via: false,
          options: {:default=>{"action"=>"index"}}
        }
      ]
    end

    def root(*args)
      match('', *args)
    end

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

      # Parse URL parts. Split on appropriate punctuation
      # (slash, parens, question mark, dot)
      parts = url.split /(\/|\(|\)|\?|\.)/
      parts.select! { |p| !p.empty? }

      vars = []
      regexp_parts = parts.map do |part|
        case part[0]
        when ':'
          # Map Variable
          vars << part[1..-1]
          '([a-zA-Z0-9]+)?'
        when '*'
          # Map Wildcard
          vars << part[1..-1]
          '(.*)'
        when '.'
          "\\." # Literal dot
        else
          part
        end
      end

      # Join the main regexp
      regexp = regexp_parts.join('')

      # Store match object
      @rules.push({
                    regexp: Regexp.new("^/#{regexp}$"),
                    vars: vars,
                    dest: dest,
                    via: options[:via] ? options[:via].downcase : false,
                    options: options
                  })
    end

    def check_url(url, method)
      (@rules + @default_rules).each do |rule|
        next if rule[:via] && rule[:via] != method.downcase

        # Check if rule against regexp
        matched_data = rule[:regexp].match(url)

        if matched_data
          # Build params hash
          options = rule[:options]
          params = options[:default].dup

          # Match variable names with the regexp captured parts
          rule[:vars].each_with_index do |var, i|
            params[var] = matched_data.captures[i]
          end

          if rule[:dest]
            # There's either a destination like 'controller#action' or a Proc
            return get_dest(rule[:dest], params)
          else
            # The params are specified in the options[:default]
            # Use controller#action to get the Rack application
            controller = params['controller']
            action = params['action']
            return get_dest("#{controller}##{action}", params)
          end
        end
      end
      nil
    end

    # Returns a Rack application or raises an error if no/invalid 'dest'
    def get_dest(dest, routing_params = {})
      return dest if dest.respond_to?(:call)

      # Ex 'controller#action'
      if dest =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        controller = Object.const_get("#{name}Controller")
        return controller.action($2, routing_params)
      end

      raise "No destination: #{dest.inspect}!"
    end
  end

  class Application
    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
      p @route_obj
    end

    def get_rack_app(env)
      raise 'No routes!' unless @route_obj

      @route_obj.check_url env['PATH_INFO'], env['REQUEST_METHOD']
    end
  end
end
