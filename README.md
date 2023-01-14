# Feet

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/feet`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

In your Rack application, add `feet` in your Gemfile
````
get 'feet'
```
And then run `bundle install`


Install the gem and add to the application's Gemfile by executing:

    $ bundle add feet

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install feet

## Usage

This projects mocks different Rails features. After installing it in your personal project, you can check some example for each feature
TODO: Write small code snippets for every one of them

- Controllers
- Views
- FileModel (for building file-base models)
- SQLiteModel ORM
- BenchMarking (Rack middleware)
- Routing

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing
The [Minitest](http://docs.seattlerb.org/minitest/) library was used for testing.

`Rake::TestTask` was configure to run the test suite. You can see a list of Rake commands with `rake -T`.
Run all tests with:

```
rake test
```
To run only one test, use:
```
rake test TEST=test/filename.rb
```

Currently, the following test files are available:
- application_test.rb
- utils_test.rb
- file_model_test.rb
- sqlite_model_test.rb
- route_test.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/feet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
