require 'csv'

class RunnerContacts
  attr_accessor :csv_file, :csv_target
  def initialize(csv_file, csv_target)
    @csv_file = csv_file
    @csv_target = csv_target
  end

  def merge_fields(args, separator)
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      merge_parts = []
      args.each do |arg|
        if !row[hash_h[arg]].nil?
          row[hash_h[arg]] = format_phone_number(row[hash_h[arg]]) if arg == 'Phone'
          merge_parts << row[hash_h[arg]]
        end
      end
      row << merge_parts.join(separator)
      rows << row
    end
    headers << 'FullName'
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

  def format_phone_number(phone_num)
    if phone_num =~ /^(\d{3})(\d{3})(\d{4})$/
      "#{$1}-#{$2}-#{$3}"
    else
      phone_num
    end
  end
end

base_path = File.dirname(__FILE__)
csv_file = File.join(base_path, 'contacts.csv')
target_csv = File.join(base_path, 'contacts_output.csv')

runnerContacts = RunnerContacts.new(csv_file, target_csv)
fields1 = ['AccountName', 'Name', 'Phone']
fields2 = ['Name', 'Phone']
runnerContacts.merge_fields(fields1, ' - ')

runnerContacts.csv_target = File.join(base_path, 'contacts_output_2.csv')
runnerContacts.merge_fields(fields2, ' - ')
