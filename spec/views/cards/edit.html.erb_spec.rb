require 'rails_helper'

RSpec.describe "cards/edit", type: :view do
  let(:card) {
    Card.create!(
      question: "MyText",
      answer: "MyText",
      deck: nil
    )
  }

  before(:each) do
    assign(:card, card)
  end

  it "renders the edit card form" do
    render

    assert_select "form[action=?][method=?]", card_path(card), "post" do
      assert_select "textarea[name=?]", "card[question]"

      assert_select "textarea[name=?]", "card[answer]"

      assert_select "input[name=?]", "card[deck_id]"
    end
  end
end
