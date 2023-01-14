# Ruby on Feet
This gem was developed part of a group study of the [Rebuilding Rails](https://rebuilding-rails.com/) book by [Noah Gibbs](https://github.com/noahgibbs).

**Ruby on Feet** is a baby Rails-like MVC framework and replicates some of the main features of Rails (see Usage).

<p align="center">
  <img src="public/cover.png" width="250" height="446" />
</p>

## Installation

In your Rack application, add `feet` in your Gemfile:

```
gem 'feet'
```

And then run `bundle install`
 
Use Feet in your app. An example app:

```ruby
# config/application.rb
require 'feet'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'app',
                        'controllers')

module MyApp
  class Application < Feet::Application; end
end
```

Initialize the application in your rack config.ru. 

```ruby
# config.ru
require './config/application'
[...]
app = MyApp::Application.new

run app
```

After, start the rackup and navigate to the `/feet` path to see Feet welcome page and more info.
You can also check this Usage section for adding controllers and further configuring routes.


## Usage

This projects mocks different Rails features. After installing it in your personal project, you can check some example for each feature (click to open the dropdown).

<details>
  <summary>Routing</summary>

  Map different routes to their controller action.
  Similar to Rails.

  ```ruby
  # config.ru
  [...]
  app.route do
      root 'home#index'

      match 'posts', 'posts#index'
      match 'posts/sql_index', 'posts#sql_index'
      match 'posts/:id', 'posts#new_quote', via: 'POST' # Use different HTTP verb with the `via` option
      match 'posts/:id', 'posts#show'

      # Get all the default resources with the `resource` method
      resource 'article'
  
      # Or just assign default routes
      match ":controller/:id/:action.(:type)?"
      match ':controller/:id/:action'
      match ':controller/:id',
              default: { 'action' => 'show' }

  end
  [...]
  ```
</details>

<details>
  <summary>Controllers</summary>
  
  ```ruby
  # app/controllers/posts_controller.rb
  class PostsController < Feet::Controller
    def show
      render :show
    end

    def index
      render :index
    end
    [...]
  end
  ```
</details>

<details>
    <summary>Views</summary>

  ```ruby
  # app/views/posts/show.html.erb
  <h1><%= @post['title'] %></h1>
  <p> <%= @post['body'] %></p>
  [...]
  ```
</details>

<details>
  <summary>FileModel (for building basic file-base models)</summary>
  <br />
  Create a directory to store the files. Each file will be a row on the DB

  The number in the file name will be the `id` of that record

  ```ruby
  # db/posts/1.json
  {
    "title": "Ruby on Feet",
    "body": "..."
  }
  ```

  Then use the `FileModel` to do CRUD operations

  ```ruby
  # app/controllers/post_controller.rb
  [...]
  def index
      @quotes = FileModel.all
      render :index
  end
  [...]
  ```
</details>

<details>
    <summary>SQLiteModel ORM</summary>

  First, create and run a mini migration to initiate the DB (test.db) and create the table (my_table). Modify the DB and table name.
  ```ruby
    # mini_migration.rb
    require 'sqlite3'

    conn = SQLite3::Database.new 'test.db'
    conn.execute <<~SQL
      create table my_table (
        id INTEGER PRIMARY KEY,
        posted INTEGER,
        title VARCHAR(30),
        body VARCHAR(32000)
      );
    SQL
  ```

  $ ruby mini_migration.rb

  ```ruby
  # app/my_table.rb
  require 'sqlite3'
  require 'feet/sqlite_model'

  class MyTable < Feet::Model::SQLiteModel; end

  # You can test different operations on MyTable
  # Create row
  mt = MyTable.create "title" => "Ruby on Feet",
    "posted" => 1, "body" => "..."
  puts "Count: #{MyTable.count}"
  mt2 = MyTable.find mt["id"]
  ```

  Then you can use MyTable in your controller to handle your DB entries

  ```ruby
  # app/controller/post_controller.rb
  require_relative '../my_table'
  class QuotesController < Feet::Controller
      def sql_index
          @results = MyTable.all

          render :sql_index
      end

      def create
        @post = MyTable.create({"title" => "Ruby on Feet", "posted" => 1, "body" => "..."})
      end
  end
  ```
  And create a view `sql_index` to render these results.

</details>

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing
The [Minitest](http://docs.seattlerb.org/minitest/) library was used for testing.

`Rake::TestTask` was configure to run the test suite. You can see a list of Rake commands with `rake -T`.

Run all tests with:

    $ rake test

To run only one test, use:

    $ rake test TEST=test/filename.rb


Currently, the following test files are available:
- application_test.rb
- utils_test.rb
- file_model_test.rb
- sqlite_model_test.rb
- route_test.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dariuspirvulescu/feet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


<!-- TODO: -->
<!-- Fix FileModel so to work with multiple models, not just quotes -->
<!-- Remove @route comment from RouteObject -->
<!-- Deploy the gem to rubygems org https://guides.rubygems.org/publishing/ -->
<!-- CHECK README FOR ANY ERROR instructions -->
