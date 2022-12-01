name = 'db/quotes/3.json'

basename = File.split(name)[-1]

p basename

id = File.basename(basename, '.json').to_i

p id
