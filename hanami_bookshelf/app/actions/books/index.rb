# frozen_string_literal: true

module HanamiBookshelf
  module Actions
    module Books
      class Index < HanamiBookshelf::Action
        def handle(request, response)
          response.render(
            view,
            page: request.params[:page] || 1,
            per_page: request.params[:per_page] || 5
          )
        end
      end
    end
  end
end
