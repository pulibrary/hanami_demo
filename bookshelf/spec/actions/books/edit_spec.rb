# frozen_string_literal: true
require 'byebug'

RSpec.describe Bookshelf::Actions::Books::Edit do
  let(:params) { Hash[ id: book.id] }
  let(:book_repo) { Bookshelf::Repos::BookRepo.new }
  let(:book) { book_repo.create(author: "Sally Smith", title: "Some Great Book")}

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
