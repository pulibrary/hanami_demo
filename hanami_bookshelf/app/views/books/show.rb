# frozen_string_literal: true

module HanamiBookshelf
  module Views
    module Books
      class Show < HanamiBookshelf::View
        include Deps["repos.book_repo"]

        expose :book do |id:|
          book_repo.get(id)
        end
      end
    end
  end
end
