require_relative '../../lib/feet/sqlite_model.rb'

class MyTable < Feet::Model::SQLiteModel; end

puts '>>> schema'
p MyTable.schema

puts '>>> table name'
p MyTable.table

puts '>>> count'
p MyTable.count

