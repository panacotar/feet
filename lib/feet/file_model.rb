require 'multi_json'

module Feet
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        # If filename is "dir/21.json", @id is 21
        basename = File.split(filename)[-1]
        @id = File.basename(basename, '.json').to_i

        row_object = File.read(filename)
        @hash = MultiJson.load(row_object)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        id = id.to_i
        @dm_style_cache ||= {}
        begin
          return @dm_style_cache[id] if @dm_style_cache[id]

          found = FileModel.new("db/quotes/#{id}.json")
          @dm_style_cache[id] = found
          found
        rescue Errno::ENOENT
          nil
        end
      end

      def self.all
        files = Dir['db/quotes/*.json']
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        # Create hash
        hash = {}
        hash['attribution'] = attrs['attribution'] || ''
        hash['submitter'] = attrs['submitter'] || ''
        hash['quote'] = attrs['quote'] || ''

        # Find highest id
        files = Dir['db/quotes/*.json']
        names = files.map { |f| File.split(f)[-1] } # transform to_i here?
        highest = names.map(&:to_i).max
        id = highest + 1

        # Open and write the new file
        new_filename = "db/quotes/#{id}.json"
        File.open("db/quotes/#{id}.json", 'w') do |f|
          f.write <<~TEMPLATE
            {
                "submitter": "#{hash['submitter']}",
                "quote": "#{hash['quote']}",
                "attribution": "#{hash['attribution']}"
            }
          TEMPLATE
        end

        # Create new FileModel instance with the new file
        FileModel.new new_filename
      end

      def save
        return 'No valid hash' unless @hash

        # Write JSON to file
        File.open(@filename, 'w') do |f|
          f.write <<~TEMPLATE
            {
                "submitter": "#{@hash['submitter']}",
                "quote": "#{@hash['quote']}",
                "attribution": "#{@hash['attribution']}"
            }
          TEMPLATE
        end

        # Return the hash
        @hash
      end

      def self.find_all_by_attribute(attribute, value)
        id = 1
        results = []
        loop do
          model = find(id)
          return results unless model

          results.push(model) if model[attribute] == value
          id += 1
        end
      end

      def self.find_all_by_submitter(name = '')
        return [] unless name

        find_all_by_attribute('submitter', name)
      end

      def self.method_missing(m, *args)
        base = /^find_all_by_(.*)/
        if m.to_s.start_with? base
          key = m.to_s.match(base)[1]
          find_all_by_attribute(key, args[0])
        else
          super
        end
      end

      def self.respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('find_all_by') || super
      end

    end
  end
end
