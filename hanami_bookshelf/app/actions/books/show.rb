# frozen_string_literal: true

module HanamiBookshelf
  module Actions
    module Books
      class Show < HanamiBookshelf::Action
        def handle(request, response)
          response.render(view, id: request.params[:id])
        end
      end
    end
  end
end
