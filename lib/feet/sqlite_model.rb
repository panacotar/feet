require 'sqlite3'
require 'feet/utils'

DB = SQLite3::Database.new 'test.db'

module Feet
  module Model
    class SQLiteModel
      def self.initialize(data = nil)
        @hash = data
      end

      def self.table
        Feet.to_snake_case name # name = method to return the class name, ex: MyName
      end

      def self.schema
        return @schema if @schema

        @schema = {}
        DB.table_info(table) do |row|
          @schema[row['name']] = row['type']
        end
        @schema
      end

      def self.to_sql(value)
        case value
        when NilClass
          'null'
        when Numeric
          value.to_s
        when String
          "'#{value}'"
        else
          raise "Can't convert #{value.class} to SQL."
        end
      end

      # Add the create method

      def self.count
        DB.execute <<~SQL
          SELECT COUNT(*) FROM #{table}
        SQL
      end

    end
  end
end
