require 'sqlite3'
require 'feet/utils'

DB = SQLite3::Database.new 'test.db'

module Feet
  module Model
    class SQLiteModel
      def self.table
        Feet.to_snake_case name
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row['name']] = row['type']
        end
        @schema
      end
    end
  end
end