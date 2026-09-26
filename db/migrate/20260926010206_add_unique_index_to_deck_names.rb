class AddUniqueIndexToDeckNames < ActiveRecord::Migration[8.1]
  def change
     add_index :decks, :name, unique: true
  end
end
