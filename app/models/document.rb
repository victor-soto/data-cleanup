# Document
class Document < ApplicationRecord
  after_destroy :delete_document

  def full_path
    Rails.root.join(folder, name)
  end

  private

  def delete_document
    File.delete(full_path) if File.exist?(full_path)
  end
end
