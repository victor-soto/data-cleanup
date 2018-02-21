require 'csv'

class RunnerAccounts
  def initialize(csv_file, csv_target)
    @csv_file = csv_file
    @csv_target = csv_target
  end

  def execute
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      contact_full_name = []
      contact_full_name << row[hash_h['contact?account']] unless row[hash_h['contact?account']].nil?
      contact_name = []
      contact_name << row[hash_h['contact?firstname']] unless row[hash_h['contact?firstname']].nil?
      contact_name << row[hash_h['contact?lastname']] unless row[hash_h['contact?lastname']].nil?
      contact_full_name << contact_name.join(' ')
      unless row[hash_h['contact?phone']].nil?
        phone = row[hash_h['contact?phone']]
        contact_full_name << format_phone_number(phone)
      end
      data = []
      data << contact_full_name.join(' - ')
      data << row[hash_h['Saleforce_ID']]
      rows << data
    end
    headers << 'contact_full_name'
    write_csv(rows)
  end

  def write_csv(rows)
    CSV.open(@csv_target, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << ['full_name', 'contact_id']
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

  def format_phone_number(phone_num)
    if phone_num =~ /^(\d{3})(\d{3})(\d{4})$/
      "#{$1}-#{$2}-#{$3}"
    else
      phone_num
    end
  end
end

base_path = File.dirname(__FILE__)
csv_file = File.join(base_path, 'accounts.csv')
target_csv = File.join(base_path, 'accounts_outpu.csv')

runner = RunnerAccounts.new(csv_file, target_csv)
runner.execute