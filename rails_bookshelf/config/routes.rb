module Bookshelf
  class Routes < Hanami::Routes
    #   resources :books
    get "/books", to: "books.index"
    get "/books/:id", to: "books.show", as: :show_book
    get "/books/new", to: "books.new"
    post "/books", to: "books.create", as: :create_book

    # TODO: We need a health check back
  end
end
