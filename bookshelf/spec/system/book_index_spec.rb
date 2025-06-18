require "spec_helper"

RSpec.describe "books/", type: :system do
  let(:books) { Hanami.app["relations.books"] }

    it "visits the home page and shows a welcome message" do
      visit "/books"
  
      expect(page).to have_content "Welcome to Rails Bookshelf"
    end

    it "shows books on the index" do
      books.insert(title: "book 1", author: "author 1", created_at: Time.now, updated_at: Time.now)
      books.insert(title: "book 2", author: "author 2", created_at: Time.now, updated_at: Time.now)
      visit "/books"
  
      expect(page).to have_content "Title: book 1"
      expect(page).to have_content "Title: book 2"
      expect(page).to have_content "Author: author 1"
      expect(page).to have_content "Author: author 2"
    end

  end
