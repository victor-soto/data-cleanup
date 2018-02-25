require 'fileutils'

# DocumentsController
class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      @document.folder = 'public/uploads/'
      FileUtils.mv('public/uploads/temp/' + @document.name, 'public/uploads/' + @document.name)
      render :index
    else
      render :new
    end
  end

  def upload_temp
    document = save_file(params[:file])
    if document.save
      render json: { document: document }
    else
      render json: { errors: document.errors }
    end
  end

  private

  def save_file(file)
    file_name = SecureRandom.urlsafe_base64 + File.extname(file.path)
    File.open(Rails.root.join('public', 'uploads', 'temp', file_name), 'wb') do |f|
      f.write(file.read)
    end
    Document.new(
      display_name: file.original_filename,
      name: file_name,
      file_type: file_ext,
      folder: 'public/uploads/temp/'
    )
  end

  def document_params
    params.require(:document).permit(:display_name, :name, :folder, :file_type)
  end
end
