require 'csv'

class RunnerProperties
  attr_accessor :csv_file, :csv_target

  def initialize(csv_file, csv_target)
    @csv_file = csv_file
    @csv_target = csv_target
  end

  def trim_last(separator, field)
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      unless row[hash_h[field]].nil?
        split_array = row[hash_h[field]].split(separator).collect(&:strip)
        row << split_array.join(' - ')
      end
      rows << row
    end
    headers << 'OwnerContactsClear'
    write_csv(rows, headers)
  end

  def split_companies(separator, field)
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      unless row[hash_h[field]].nil?
        split_array = row[hash_h[field]].split(separator).collect(&:strip)
        if split_array.length >= 2
          row << split_array[0..1].join(' - ')
          row << split_array[0]
        else
          row << split_array[0]
        end
      end
      rows << row
    end
    headers << 'OwnerContactsClear'
    headers << 'OwnerContactsClear2'
    write_csv(rows, headers)
  end

  private

  def headers_to_hash(headers)
    headers_hash = {}
    headers.each_with_index do |header, index|
      headers_hash[header] = index
    end
    headers_hash
  end

  def write_csv(rows, headers)
    CSV.open(@csv_target, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << headers
      rows.each do |w|
        row << w
      end
    end
  end
end

base_path = File.dirname(__FILE__)
csv_file = File.join(base_path, 'properties.csv')
target_csv = File.join(base_path, 'properties_output.csv')

runnerProperties = RunnerProperties.new(csv_file, target_csv)
runnerProperties.trim_last(' - ', 'OwnerContacts')
runnerProperties.csv_target = File.join(base_path, 'properties_output_2.csv')
runnerProperties.split_companies(' - ', 'OwnerContacts')
