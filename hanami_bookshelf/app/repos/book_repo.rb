# frozen_string_literal: true

module HanamiBookshelf
  module Repos
    class BookRepo < HanamiBookshelf::DB::Repo
      def all_by_title(page:, per_page:)
        books
          .order(books[:title].asc)
          .page(page)
          .per_page(per_page)
          .to_a
      end

      def get(id)
        books.by_pk(id).one!
      end

      def create(attributes)
        books.changeset(:create, attributes).commit
      end
    end
  end
end
