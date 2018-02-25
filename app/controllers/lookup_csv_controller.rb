require 'lookup_csv/lookup_csv_generator'

# LookupCsvController
class LookupCsvController < ApplicationController
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

  def create
    csv_file = lookup_csv(lookup_params)
    file = File.open(csv_file.full_path)
    send_data(
      file.read,
      type: 'text/csv; charset=iso-8859-1; header=present',
      disposition: 'attachment;data=' + csv_file.name,
      filename: csv_file.name
    )
  end

  private

  def save_file(file)
    file_ext = File.extname(file)
    file_name = SecureRandom.urlsafe_base64 + file_ext
    File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |f|
      f.write(file.read)
    end
  end

  def lookup_params
    params.require(:lookup).permit(
      :target_id,
      :source_id,
      :target_header,
      :source_header_comparer,
      :source_header_value
    )
  end

  def lookup_csv(lookup_params)
    LookupCsv::LookupCsvGenerator.new(
      Document.find(lookup_params[:target_id]),
      Document.find(lookup_params[:source_id]),
      lookup_params[:target_header],
      lookup_params[:source_header_comparer],
      lookup_params[:source_header_value]
    ).call
  end
end
