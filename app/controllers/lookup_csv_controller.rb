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
    file_target = Document.find(params[:csv_1])
    file_source = Document.find(params[:csv_2])
    csv_target = Rails.root.join(file_target.folder, file_target.name)
    csv_source = Rails.root.join(file_source.folder, file_source.name)
    target_file = File.open(csv_target, encoding: 'iso-8859-1')
    source_file = File.open(csv_source, encoding: 'iso-8859-1')


    lines = CSV.open(target_file, encoding: 'iso-8859-1').readlines
    keys = lines.delete lines.first

    data = lines.map do |values|
      is_int(values) ? values.to_i : values.to_s
      Hash[keys.zip(values)]
    end
    

    render json: { csv_target: JSON.pretty_generate(data) }
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
