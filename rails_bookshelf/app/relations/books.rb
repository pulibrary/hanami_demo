# frozen_string_literal: true

module Bookshelf
  module Relations
    class Books < Bookshelf::DB::Relation
      schema :books, infer: true do
        attribute :created_at, Types::DateTime
      end
    end
  end
end
