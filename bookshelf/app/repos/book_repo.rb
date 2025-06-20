# frozen_string_literal: true

module Bookshelf
  module Repos
    class BookRepo < Bookshelf::DB::Repo

      def get(id)
        books.by_pk(id).one!
      end
    end
  end
end
