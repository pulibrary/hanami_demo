require "spec_helper"

RSpec.describe "books/new", type: :system do
    let(:book_repo) { Bookshelf::Repos::BookRepo.new }

    it "visits the home page and we can create books" do
      visit "/"

      click_on "New book"

      fill_in "Title", with: "awesome book"
      fill_in "Author", with: "Jane Doe"

      click_on "Create Book"
      expect(page).to have_content("Book was successfully created")
      expect(page).to have_content "Title: awesome book"

      click_on "Back to books"

      click_on "New book"

      fill_in "Title", with: "My Great Book"
      fill_in "Author", with: "Sally Smith"

      click_on "Create Book"
      expect(page).to have_content("Book was successfully created")
      expect(page).to have_content "Title: My Great Book"
      click_on "Back to books"

      expect(page).to have_content "Title: awesome book"
      expect(page).to have_content "Title: My Great Book"
    end
  end
