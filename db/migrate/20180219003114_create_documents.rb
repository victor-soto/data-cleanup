class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :display_name
      t.string :folder
      t.string :file_type
      t.integer :user_id

      t.timestamps
    end
  end
end
