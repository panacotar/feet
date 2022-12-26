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
        keys = schema.keys
        response = DB.execute <<~SQL
          SELECT #{keys.join ','} FROM #{table} WHERE id = #{id}
        SQL
        return nil unless response[0]

        data = Hash[keys.zip response[0]]
        self.new data
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(key, value)
        @hash[key] = value
      end

      def save!
        return nil unless @hash['id']

        hash_map = @hash.keys.map do |key|
          "#{key} = #{self.class.to_sql(@hash[key])}"
        end

        DB.execute <<~SQL
          UPDATE #{self.class.table}
          SET #{hash_map.join ','}
          WHERE id = #{@hash['id']};
        SQL
        @hash
      end

      def convert(field, type)
        val = @hash[field]
        case type
        when 'string'
          val.to_s
        when 'boolean'
          val.zero? ? false : true
        else
          raise NotImplementedError
        end
      end

      def self.all
        keys = schema.keys
        rows = DB.execute <<~SQL
          SELECT * FROM #{table}
        SQL

        rows.map do |row|
          data = Hash[keys.zip row]
          self.new data
        end
      end

      def self.count
        db_result = DB.execute <<~SQL
          SELECT COUNT(*) FROM #{table};
        SQL
        db_result[0][0]
      end

      def method_missing(method, *args)
        # Check for getter
        if @hash[method.to_s]
          self.class.define_method(method) do
            self[method]
          end
          return send(method)
        end

        # Check for setters
        if method.to_s[-1..-1] == '='
          field = method.to_s[0..-2]
          self.class.class_eval do
            define_method(method) do |value|
              self[field] = value
            end
          end
          return self.send(method, args[0])
        end

        super
      end

      # def define_setter(method)
      #   self.class.define_method(method) do |value|
      #     puts 'value there'
      #     p value
      #     self[method.to_s]
      #   end
      # end

      # def define_getter(method)
      #   self.class.define_method(method) do
      #     self[method.to_s]
      #   end
      # end

    end
  end
end
