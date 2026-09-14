require "application_system_test_case"

class DecksTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit decks_url

    assert_selector "h1", text: "My Decks"
  end

  test "creating a new deck" do
    visit decks_url

    click_on "Create New Deck"

    fill_in "Name", with: "Ruby"
    fill_in "Description", with: "Ruby programming"

    click_on "Create Deck"

    assert_text "Ruby"
    assert_text "Ruby programming"
  end
end