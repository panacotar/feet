require_relative '../../lib/feet/file_model.rb'

name = 'public/exp/db/quotes/3.json'

basename = File.split(name)[-1]

p basename

id = File.basename(basename, '.json').to_i

p id

file = Feet::Model::FileModel.new(name)

# p file.send(:[], 'Marco')

p file['Marco']
