# frozen_string_literal: true

module HanamiBookshelf
  module Relations
    class Books < HanamiBookshelf::DB::Relation
      schema :books, infer: true
    end
  end
end
