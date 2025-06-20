# frozen_string_literal: true

module Bookshelf
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.
    get "/books", to: "books.index",  as: :books
    get "/books/:id", to: "books.show", as: :show_book
    get "/books/new", to: "books.new", as: :new_book
    post "/books", to: "books.create", as: :create_book
  end
end
