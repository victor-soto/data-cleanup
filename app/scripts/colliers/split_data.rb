require 'csv'

class SplitData
  def initialize(csv_file, csv_target)
    @csv_file = csv_file
    @csv_target = csv_target
  end

  def execute
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|      
      rows << split_by(' - ', row[hash_h['ManagementContacts']])
    end
    headers << 'AccountName'
    write_csv(rows, headers)
  end

  def write_csv(rows, headers)
    CSV.open(@csv_target, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << headers
      rows.each do |w|
        row << w
      end
    end
  end

  private

  def headers_to_hash(headers)
    headers_hash = {}
    headers.each_with_index do |header, index|
      headers_hash[header] = index
    end
    headers_hash
  end

  def split_by(separator, text)
    unless row[hash_h['ManagementContacts']].nil?
      row[hash_h['ManagementContacts']].split(' - ')[0]
      row_parts
    end
  end
end

base_path = File.dirname(__FILE__)
csv_file = File.join(base_path, 'properties_success_all.csv')
target_csv = File.join(base_path, 'properties_success_all_otuput.csv')

runner = SplitData.new(csv_file, target_csv)
runner.execute
