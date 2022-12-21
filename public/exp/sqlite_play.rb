require_relative '../../lib/feet/sqlite_model.rb'

class MyTable < Feet::Model::SQLiteModel; end

puts '>>> schema'
p MyTable.schema

puts '>>> table name'
p MyTable.table

puts '>>> count'
total_count = MyTable.count
p total_count

# puts '>>> create'
# item = {"title"=>"Sensational", "id"=>2121, "posted"=>1, "body"=>"whatevs"}
# result = MyTable.create(item)
# p result

# puts '>>> new instance'
# it = {"posted"=>1, "title"=>"my title", "body"=>"whatevs", "id"=>7}
# a = MyTable.new(it)
# p a

puts '>>> find'
found7 = MyTable.find(7)
p MyTable.find(11111) # Should not be found
p found7
puts "Found record with id 7, title -->: #{found7['title']}"

# puts '>>> Print all'
# (1..total_count).each do |id|
#   result = MyTable.find(id)
#   puts "Found title: #{result['title']}"
# end

# found7['title'] = 'Whatevr again!'
# p found7.save!

# all = MyTable.all
# puts 'all'
# p all