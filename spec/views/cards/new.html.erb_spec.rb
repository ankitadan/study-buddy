require 'rails_helper'

RSpec.describe "cards/new", type: :view do
  before(:each) do
    assign(:card, Card.new(
      question: "MyText",
      answer: "MyText",
      deck: nil
    ))
  end

  it "renders new card form" do
    render

    assert_select "form[action=?][method=?]", cards_path, "post" do
      assert_select "textarea[name=?]", "card[question]"

      assert_select "textarea[name=?]", "card[answer]"

      assert_select "input[name=?]", "card[deck_id]"
    end
  end
end
