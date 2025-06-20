# frozen_string_literal: true

module Bookshelf
  module Views
    module Books
      class New < Bookshelf::View
        expose :book do
          nil
        end
    
        expose :form_path do
          Hanami.app["routes"].path(:create_book)
        end

        expose :form_method do 
          "POST"
        end

        expose :submit_label do
          'Create'
        end
      end
    end
  end
end
