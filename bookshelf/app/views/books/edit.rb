# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
      class Edit < Bookshelf::View
        include Deps["repos.book_repo"]

        expose :book do |id:|
          book_repo.get(id)
        end

        expose :form_path do |id:|
          Hanami.app["routes"].path(:update_book, id:)
        end

        expose :form_method do 
          "PATCH"
        end

        expose :submit_label do
          'Update'
        end
      end
    end
  end
end
