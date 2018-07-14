class CreateQaLocalAuthorityEntries < ActiveRecord::Migration
  def change
    create_table :qa_local_authority_entries do |t|
      t.integer :local_authority_id
      t.string :label
      t.string :uri

      t.timestamps null: false
    end
    add_index :qa_local_authority_entries, :uri
    add_index "qa_local_authority_entries", ["local_authority_id"], name: "index_qa_local_authority_entries_on_local_authority_id"

  end
end
