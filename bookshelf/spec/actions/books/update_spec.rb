# frozen_string_literal: true
require 'byebug'

RSpec.describe Bookshelf::Actions::Books::Update do
  let(:params) { Hash[ id: book.id, book: { author: "Sally Smithers", title: "Some New Great Book"} ] }
  let(:book_repo) { Bookshelf::Repos::BookRepo.new }
  let(:book) { book_repo.create(author: "Sally Smith", title: "Some Great Book")}

  it "works" do
    response = subject.call(params)
    expect(response).to be_redirection
    expect(response.location).to eq(Hanami.app["routes"].path(:show_book, id: book.id))
    updated_book = book_repo.get(book.id)
    expect(updated_book.title).to eq("Some New Great Book")
  end
end
