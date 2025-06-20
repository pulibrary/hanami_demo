# frozen_string_literal: true
require 'byebug'

module Bookshelf
  module Actions
    module Books
      class Update < Bookshelf::Action
        include Deps["repos.book_repo"]

        params do
          required(:id).value(:integer)
          required(:book).hash do
            required(:title).filled(:string)
            required(:author).filled(:string)
          end
        end

        def handle(request, response)
          if request.params.valid?
            book = book_repo.update(request.params[:id], request.params[:book])

            response.flash[:notice] = "Book was successfully update"
            response.redirect_to routes.path(:show_book, id: book[:id])
          else
            response.flash.now[:alert] = "Could not update book"
            response.render(Bookshelf::Views::Books::Edit.new, id: request.params[:id])
          end
        end
      end
    end
  end
end
