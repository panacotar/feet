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
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue => e
          nil
        end
      end

    end
  end
end
