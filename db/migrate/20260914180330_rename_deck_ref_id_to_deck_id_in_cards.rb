class RenameDeckRefIdToDeckIdInCards < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    execute "PRAGMA foreign_keys = OFF"

    remove_foreign_key :cards, column: :deck_ref_id
    rename_column :cards, :deck_ref_id, :deck_id
    add_foreign_key :cards, :decks
  ensure
    execute "PRAGMA foreign_keys = ON"
  end

  def down
    execute "PRAGMA foreign_keys = OFF"

    remove_foreign_key :cards, column: :deck_id
    rename_column :cards, :deck_id, :deck_ref_id
  ensure
    execute "PRAGMA foreign_keys = ON"
  end
end