# frozen_string_literal: true

module HanamiBookshelf
  module Views
    module Books
      class Index < HanamiBookshelf::View
        expose :books do
          [
            {title: "Test Driven Development"},
            {title: "Practical Object-Oriented Design in Ruby"}
          ]
        end
      end
    end
  end
end
