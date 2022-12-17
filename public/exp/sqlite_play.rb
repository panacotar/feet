require_relative '../../lib/feet/sqlite_model.rb'

class MyTable < Feet::Model::SQLiteModel; end

puts '>>> schema'
p MyTable.schema

puts '>>> table name'
p MyTable.table

puts '>>> count'
p MyTable.count

puts '>>> create'
item = {"title"=>"Sensational", "id"=>2121, "posted"=>1, "body"=>"whatevs"}
result = MyTable.create(item)
p result

# puts '>>> new instance'
# it = {"posted"=>1, "title"=>"my title", "body"=>"whatevs", "id"=>7}
# a = MyTable.new(it)
# p a
