require 'csv'
require 'csv_util'

# CsvEngineController
class CsvEngineController < ApplicationController
  before_action :load_folders

  def lookup
    @csv_target = @csv_util.open_csv(@target_path, true)
    @csv_origin = @csv_util.open_csv(@origin_path, true)
  end

  def generate_lookup_csv
    target_headers = @csv_util.get_headers(@target_path)
    target_hash_headers = @csv_util.headers_to_hash(target_headers)
    origin_lookup_hash = {}
    origin_headers = @csv_util.get_headers(@origin_path)
    origin_hash_headers = @csv_util.headers_to_hash(origin_headers)
    output_path = File.join(@public_folder, 'output.csv')
    fill_lookup_hash(
      @origin_path,
      origin_lookup_hash,
      origin_hash_headers,
      params[:column2],
      params[:column3]
    )
    output = []
    fill_output(
      @target_path,
      origin_lookup_hash,
      target_hash_headers,
      output,
      params[:column3],
      params[:column1]
    )
    write_output(output_path, target_headers, params[:column3], output)
    file = File.open(output_path)
    send_data(
      file.read,
      type: 'text/csv; charset=iso-8859-1; header=present',
      disposition: 'attachment;data=output.csv',
      filename: "output-#{SecureRandom.urlsafe_base64}.csv"
    )
  end

  private

  # def get_headers(file)
  #   CSV.read(file, headers: true, encoding: 'iso-8859-1:utf-8').headers
  # end

  def iterate_csv(path)
    options = { headers: true, encoding: 'iso-8859-1:utf-8' }
    CSV.foreach(path, options) do |on|
      yield(on)
    end
  end

  def write_csv(path)
    options = { encoding: 'iso-8859-1:utf-8' }
    CSV.open(path, 'wb', options) do |on|
      yield(on)
    end
  end

  def load_folders
    @public_folder = File.join(Dir.pwd, 'public', 'files')
    @target_path = File.join(@public_folder, 'Contacts.csv')
    @origin_path = File.join(@public_folder, 'AccountsSuccess.csv')
    @csv_util = CsvUtil.new
  end

  def write_output(output_path, target_headers, param, output)
    write_csv(output_path) do |row|
      target_headers = target_headers << param
      row << target_headers
      output.each do |o|
        row << o
      end
    end
  end

  def fill_lookup_hash(
    origin_path,
    origin_lookup_hash,
    origin_hash_headers,
    param2,
    param3
  )
    iterate_csv(origin_path) do |row|
      origin_lookup_hash[
        row[
          origin_hash_headers[
            param2]]] = row[origin_hash_headers[param3]]
    end
  end

  def fill_output(
    target_path,
    origin_lookup_hash,
    target_hash_headers,
    output,
    param3,
    param1
  )
    iterate_csv(target_path) do |row|
      lookup_value = {}
      lookup_value[
        param3] = origin_lookup_hash[
          row[
            target_hash_headers[
              param1]]]
      row << lookup_value
      output.push(row)
    end
  end
end
