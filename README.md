This is a set of demo applications that we are using to determin how difficult it is to convert a Rails project into a Hanami project

The rails project can be run by following
```
cd rails_bookshelf
bundle exec rails s
```
view the app at http://locahlost:3000

The hanami project cab be run by following
```
cd hanami_bookshelf
bundle install
npm install
bundle exec hanami assets compile
bundle exec hanami dev
```
view the app at http://localhost:2300

To load books into your hanami app run
```
bundle exec hanami console
books = Hanami.app["relations.books"]
books.insert(title: "Practical Object-Oriented Design in Ruby", author: "Sandi Metz")
books.insert(title: "Test Driven Development", author: "Kent Beck")
```

## Conversion

1. update the Gemfile
  find any rails gems and replace them with hanami if a hanami gem exists

1. bundle install
  
1. Create the hanami config `config/app.rb`
   ```

   require "hanami"

   module Bookshelf
     class App < Hanami::App
        config.actions.sessions = :cookie, {
            key: "bookshelf.session",
            secret: settings.session_secret,
            expire_after: 60*60*24*365
        }
     end
   end
   ```
  
1. Create the hanami settings config `config/settings.rb`
   ```
   module Bookshelf
     class Settings < Hanami::Settings
        # Define your app settings here, for example:
        #
        # setting :my_flag, default: false, constructor: Types::Params::Bool
        setting :session_secret, constructor: Types::String
     end
   end
   ```

1. Hanami expects a `.env` file instead of the `config/environment.rb`  We could likely do something to read in the rails environment, but for the moment, just create the `.env` file and add the session secret
   ```
   # This is checked into source control, so put sensitive values into `.env.local`
   DATABASE_URL=sqlite://storage/test.sqlite3
   SESSION_SECRET=__local_development_secret_only__
   ```

1. run hanami install to update rspec
   ```
   bundle exec hanami install
   ```

1. Update the specs to not use rails
   1. require that in all the test files
      replace `require "rails_helper"` with `require "spec_helper"` 

1. Configure the Routes `config/routes.rb`
   1. change the outer config to look like and remove rails references
      ```
      module Bookshelf
        class Routes < Hanami::Routes
        ...
        end
      end
      ```
   1. replace each `resources <>` with a set of hanami routes
      ```
      get "/books", to: "books.index"
      get "/books/:id", to: "books.show"
      get "/books/:id", to: "books.show", as: :show_book
      get "/books/new", to: "books.new"
      post "/books", to: "books.create", as: :create_book
      ```

1. For each rout you need to define a Hanami action, which will be a part of the original controller.  In hanami each action is it's own class


1. Create the needed database files
   1. `mkdir app/db`
   1. download `relation.rb`, `repo.rb` and `struct.rb` from https://github.com/hanami/cli/blob/main/lib/hanami/cli/generators/gem/app into the db directory
   1. Update each file to have your application name ( `Bookshelf`)

1. Make sure the .env file is pointed at your rails database in storage. for example `sqlite://storage/development.sqlite3`

1. Convert your model(s)
  A Rails model is a combination of a Hanami Relation and a Hanami Repo.  The relation includes the tasks to load and store the data.  The repo includes the task to find the data.
   1. creating the repo `bundle exec hanami generate relation books`
     This will create a file `app/relations/books.rb`
     At this point we will not add any additional code into the repo.  Note it infers the columns from the database

     1. test that you still have access to your old database objects by running
        ```
        hanami console
        books = Hanami.app["relations.books"]
        books.to_a
        ```
        Should return a list of existing books
   1. creating the relation `bundle exec hanami generate repo book`
       Again at this point we are not making any changes, but this is where we would put custom queries
   1. convert references to the model in your tests
      1. Book.last becomes
         ```
         books =  Hanami.app["relations.books"]
         books.last
         ```
      1. Book.create becomes (you need to set the times `, created_at: Time.now, updated_at: Time.now`)
         ```
         books =  Hanami.app["relations.books"]
         books.insert
         ```
1. Convert your Controllers into actions
   In Haanami controllers are broken out into a separate class for every action (or route) in the controller
   1. create `app/action.rb` by copying the contents of https://github.com/hanami/cli/blob/main/lib/hanami/cli/generators/gem/app/action.erb Updating the name to be `Bookshelf`
   1. create `app/view.rb` by copying the contents of https://github.com/hanami/cli/blob/main/lib/hanami/cli/generators/gem/app/view.erb Updating the name to be `Bookshelf`
   1. create `app/templates/layouts/app/html.erb` by copying the contents of https://github.com/hanami/cli/blob/main/lib/hanami/cli/generators/gem/app/app_layout.erb Updating the name to be `Bookshelf`
      ```
      mkdir app/templates/layouts 
      cd app/templates/layouts
      wget https://raw.githubusercontent.com/hanami/cli/refs/heads/main/lib/hanami/cli/generators/gem/app/app_layout.erb
      mv app_layout.erb app.html.erb
      cd -
      ```
   1. generate an action for each route
      ```
      bundle exec hanami generate action books.index --skip-tests
      ```
   1. copy the code from the old controller into the action
   1. convert @ values `@books` into an expose in the view
      ```
        include Deps["repos.book_repo"]

        expose :books do
          book_repo.all
        end
      ```

