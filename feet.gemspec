# frozen_string_literal: true

require_relative 'lib/feet/version'

Gem::Specification.new do |spec|
  spec.name = 'feet'
  spec.version = Feet::VERSION
  spec.authors = ['Darius Pirvulescu']
  spec.email = ['organicdarius@gmail.com']

  spec.summary = 'Hairy rails twin'
  spec.description = 'A more down to earth, hairy rails twin'
  spec.homepage = 'https://i.etsystatic.com/13348558/r/il/a29ab1/2918306283/il_570xN.2918306283_ojql.jpg'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/panacotar/feet'
  spec.metadata['changelog_uri'] = 'https://github.com/panacotar/feet/pulls?q=is%3Apr+is%3Aclosed'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'

  spec.add_runtime_dependency 'erubis'
  spec.add_runtime_dependency 'multi_json'
  epec.add_runtime_dependency 'rack', '~>2.2'
  spec.add_runtime_dependency 'sqlite3'

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rack-test'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
