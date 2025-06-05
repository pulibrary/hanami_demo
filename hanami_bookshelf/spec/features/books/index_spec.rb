# spec/features/books/index_spec.rb

RSpec.feature "Books index" do
    it "shows a list of books" do
      visit "/books"
  
      expect(page).to have_selector "li", text: "Test Driven Development"
      expect(page).to have_selector "li", text: "Practical Object-Oriented Design in Ruby"
    end
  end
  