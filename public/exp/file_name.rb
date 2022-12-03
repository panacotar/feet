require_relative '../../lib/feet/file_model.rb'

path = 'public/exp/db/quotes/3.json'

base = File.dirname(__FILE__)

name = File.join(base, path)

basename = File.split(name)[-1]

p basename

id = File.basename(basename, '.json').to_i

p id

file = Feet::Model::FileModel.new(path)

p file['Marco']

def find(id)
  found = Feet::Model::FileModel.find(id)

  puts 'found'
  p found
end

find(3)

def index
  files = Dir['public/exp/db/quotes/*.json']

  files.map { |f| Feet::Model::FileModel.new f }

  p files
end

index