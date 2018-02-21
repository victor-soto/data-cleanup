require 'csv'
# Runner unescaped characters content notes salesforce
class Runner
  def initialize(csv_file, target_csv)
    @csv_file = csv_file
    @target_csv = target_csv
  end

  def replace_characters
    rows = []
    headers = CSV.read(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8').headers
    hash_h = headers_to_hash(headers)
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      row[hash_h['Description']] = replace_unescaped_characters(row[hash_h['Description']])
      additional_rows(row, hash_h)
      rows << row
    end
    put_additional_headers(headers)
    write_csv(rows, headers)
  end

  private

  def replace_unescaped_characters(str)
    if !str.nil?
      replacements = [['&', '&amp;'], ['<', '&lt;'], ['>', '&gt;'], ['"', '&quot;'], ['\'', '&#39;']]
      replacements.each { |replacement| str.gsub!(replacement[0], replacement[1]) }
      str
    else
      ''
    end
  end

  def write_csv(rows, headers)
    CSV.open(@target_csv, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << headers
      rows.each do |w|
        row << w
      end
    end
  end

  def headers_to_hash(headers)
    headers_hash = {}
    headers.each_with_index do |header, index|
      headers_hash[header] = index
    end
    headers_hash
  end

  def id?(str)
    !str.nil?
  end

  def put_additional_headers(headers)
    headers << 'HaveOpportunityId'
    headers << 'HaveWhoID'
  end

  def additional_rows(row, hash_h)
    row << id?(row[hash_h['OpportunityId']])
    row << id?(row[hash_h['WhoID']])
  end
end

base_path = File.dirname(__FILE__)
csv_file = File.join(base_path, 'notes3.csv')
target_csv = File.join(base_path, 'notes_3_unescaped_characters.csv')

runner = Runner.new(csv_file, target_csv)
runner.replace_characters
