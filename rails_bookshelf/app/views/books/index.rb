# frozen_string_literal: true
require 'byebug'

module Bookshelf
  module Views
    module Books
      class Index < Bookshelf::View
        include Deps["repos.book_repo"]

        expose :books do
          book_repo.books.to_a
        end
      end
    end
  end
end
