class AddProcessToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :processed, :boolean, default: false
  end
end
