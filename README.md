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