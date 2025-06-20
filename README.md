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

## Conversion Rails to Hanami

1. Generate a hanami app beside you rails app 
   This step will allow us to copy the rails application logic into the hanami app
   The generator for the application creates a framework that is hard to duplicate by hand
   ```
   hanami new bookshelf
   ```

1. Move the storage if you are utilizing sqllite, and/or point the .env file to the correct database
   1. `cp rails_bookshelf/storage/* bookshelf/db/`
   1. edit `bookshelf/.env` set `DATABASE_URL=sqlite://db/development.sqlite3`

1. Setup session secrets
    1. Update the hanami config `config/app.rb` to allow for session cookies
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

    1. update the hanami settings config `config/settings.rb` to include a session_secret setting
    This enables encrypted cookies
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
    1. Add a session secret in the `.env` file. We could likely do something to read in the rails environment, but for the moment, 
      ```
      # This is checked into source control, so put sensitive values into `.env.local`
      DATABASE_URL=sqlite://db/development.sqlite3
      SESSION_SECRET=__local_development_secret_only__
      ```
1. Copy the tests from the rails app to run in the hanami app
    1. copy the specs from the rails app into the new application
    ```
    mkdir bookshelf/spec/system
    cp rails_bookshelf/spec/system/* bookshelf/spec/system
    ```

    1. Update the specs to not use rails
    1. require that in all the test files
        replace `require "rails_helper"` with `require "spec_helper"` 
    1. the test should now run, but fail with errors like `uninitialized constant Book`
       ```
       cd bookshelf
       bundle install
       rspec
       ```
1. Convert your model(s)
  A Rails model is a combination of a Hanami Relation and a Hanami Repo.  The relation includes the tasks to load and store the data.  The repo includes the task to find the data.
   1. creating the repo `bundle exec hanami generate relation books`
     This will create a file `app/relations/books.rb`
     At this point we will not add any additional code into the relation.  Note it infers the columns from the database
     1. test that you still have access to your old database objects by running
        ```
        hanami console
        books = Hanami.app["relations.books"]
        books.to_a
        ```
        Should return a list of existing books
   1. creating the repo `bundle exec hanami generate repo book`
     1. define last on the repo in `app/repos/book_repo.rb` by adding the following code
        ```
        def last = books.last
        ```
     1. define create on the repo in `app/repos/book_repo.rb` by adding the following code
        ```
        def create(attributes)
            attributes[:created_at] = Time.now
            attributes[:updated_at] = Time.now
            books.changeset(:create, attributes).commit
        end
        ```

   1. convert references to the model in your tests
      1. Book.last becomes
         ```
         book_repo =  Bookshelf::Repos::BookRepo.new
         book_repo.last
         ```
      1. Book.create becomes
         ```
         book_repo =  Bookshelf::Repos::BookRepo.new
         book_repo.create()
         ```
   1. re-run your tests.  You should no longer get any `uninitialized constant Book` errors, but they should all still fail
1. Convert you controller(s)
   A rails Controller becomes many Hanami Actions.  One action is created for each route the controller handles (show, new, create, index, update ...)
   1. Choose an action and run the hanami generator for that action
      we are going to skip the tests since we are leaning on the rails tests to make sure our Hanami system behaves the same way our Rails system did.
      ```
      bundle exec hanami generate action books.index --skip-tests
      ```
      The above command created a number of files that we now need to adjust based on the code in our Rails application

      1. convert @ values (`@books`) into an expose in the view
        in `app/views/books/index.rb` inside `class Index < Bookshelf::View` block add           
        ``` 
        include Deps["repos.book_repo"]

        expose :books do
            book_repo.books.to_a
        end
        ```
        If there was specific sorting we would add a custom method to the repo and utilize that in the expose
      1. copy the rails view `rails_bookshelf/app/views/books/index.html.erb` into the hanami template director `bookshelf/app/templates/books/index.html.erb`
         1. change any `@books` to the expose `books` in the template
         1. change any `render...` to include the name of the partial and the locals needed explicitly (you can no longer render a model and expect the partial to be chosen)
         1. modify any link_to to include the `route.` in front of the name and make sure the route is named in `config/routes.rb`
         1. change and flash messages `notice` to `flash[:notice]`
      1. make changes to make th tests pass
   1. Choose another action and repeat until you have done all the actions.  Remember for a form you need both the form show and   form submit actions


