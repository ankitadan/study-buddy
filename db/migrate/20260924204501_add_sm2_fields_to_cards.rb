class AddSm2FieldsToCards < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :repetition, :integer, default: 0, null: false
    add_column :cards, :interval, :integer, default: 0, null: false
    add_column :cards, :ease_factor, :float, default: 2.5, null: false
    add_column :cards, :next_review_date, :date
  end
end
