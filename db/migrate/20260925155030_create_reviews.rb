class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :card, null: false, foreign_key: true
      t.integer :quality, null: false
      t.date :reviewed_on, null: false

      t.timestamps
    end

    add_index :reviews, [ :card_id, :reviewed_on ]
  end
end
