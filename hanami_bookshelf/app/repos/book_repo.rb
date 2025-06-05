# frozen_string_literal: true

module HanamiBookshelf
  module Repos
    class BookRepo < HanamiBookshelf::DB::Repo
      def all_by_title
        books.order(books[:title].asc).to_a
      end
    end
  end
end
