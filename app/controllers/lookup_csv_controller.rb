# LookupCsvController
class LookupCsvController < ApplicationController
  # before_action :file_paths, on: :upload
  def new; end

  def upload
    csv_target = params[:csv_1]
    csv_source = params[:csv_2]
    save_file(csv_target)
    save_file(csv_source)
  end

  def preview
    file = Document.find(params[:id])
    csv_header = Rails.root.join(file.folder, file.name)
    headers = CSV.read(csv_header, headers: true, encoding: 'iso-8859-1').headers
    render json: { csv_headers: headers }
  end

  private

  def save_file(file)
    file_ext = File.extname(file)
    file_name = SecureRandom.urlsafe_base64 + file_ext
    File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |f|
      f.write(file.read)
    end
  end

  def is_int(str)
    # Check if a string should be an integer
    return !!(str =~ /^[-+]?[1-9]([0-9]*)?$/)
  end



  # def file_paths
  #   csv_target = params[:csv_1]
  #   csv_source = params[:csv_2]
  # end
end
