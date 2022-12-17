require 'sqlite3'
require 'feet/utils'

DB = SQLite3::Database.new 'test.db'

module Feet
  module Model
    class SQLiteModel
      def initialize(data = nil)
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

      def self.create(initial_hash)
        # Get initial_hash and schema keys without ids and map initial_hash to schema keys
        initial_hash.delete 'id'
        keys = schema.keys - ['id']
        sql_values = keys.map do |key|
          initial_hash[key] ? to_sql(initial_hash[key]) : 'null'
        end

        # Insert values into table
        DB.execute <<~SQL
          INSERT INTO #{table} (#{keys.join ','}) VALUES (#{sql_values.join ','});
        SQL

        # Build and return the new table entry
        raw_values = keys.map { |k| initial_hash[k] }
        data = Hash[keys.zip raw_values]

        # Get the latest id
        sql = 'SELECT last_insert_rowid();'
        data['id'] = DB.execute(sql)[0][0]

        self.new data
      end

      def self.find(id)
        response = DB.execute <<~SQL
          SELECT * FROM #{table} WHERE id = #{id}
        SQL
        keys = schema.keys
        response[0] ? Hash[keys.zip response[0]] : nil
      end

      def self.count
        db_result = DB.execute <<~SQL
          SELECT COUNT(*) FROM #{table};
        SQL
        db_result[0][0]
      end

    end
  end
end
