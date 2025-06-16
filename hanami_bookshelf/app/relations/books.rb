# frozen_string_literal: true

module HanamiBookshelf
  module Relations
    class Books < HanamiBookshelf::DB::Relation
      schema :books, infer: true

      use :pagination
      per_page 5
    end
  end
end
