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
