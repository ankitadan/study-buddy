require 'rails_helper'

RSpec.describe "cards/index", type: :view do
  before(:each) do
    assign(:cards, [
      Card.create!(
        question: "MyText",
        answer: "MyText",
        deck: nil
      ),
      Card.create!(
        question: "MyText",
        answer: "MyText",
        deck: nil
      )
    ])
  end

  it "renders a list of cards" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
