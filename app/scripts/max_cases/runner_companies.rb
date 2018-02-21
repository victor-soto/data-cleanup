require 'csv'

# RunnerCompanies
class RunnerCompanies
  def initialize(csv_source, csv_output)
    @csv_source = csv_source
    @csv_output = csv_output
  end

  def execute
    headers = get_headers(@csv_source)
    hash_headers = headers_to_hash(headers)
    write_rows = []

    read_data(@csv_source, hash_headers, write_rows)
    write_data(@csv_output, hash_headers, headers, write_rows)
  end

  private

  def read_data(csv_file, hash_headers, write_rows)
    CSV.foreach(csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      unless row[hash_headers['companies']].nil?
        row[hash_headers['companies']] = row[hash_headers['companies']].split(',')[0]
      end
      write_rows << row
    end
  end

  def write_data(csv_file, hash_headers, headers, write_rows)
    CSV.open(csv_file, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << headers
      write_rows.each do |w_r|
        drop_token(w_r[hash_headers['companies']], '"')
        w_r[hash_headers['companies']] = drop_token(w_r[hash_headers['companies']], '"')
        row << w_r
      end
    end
  end

  def drop_token(text, _token)
    text.delete('"') unless text.nil?
  end

  def headers_to_hash(headers)
    headers_hash = {}
    headers.each_with_index do |header, index|
      headers_hash[header] = index
    end
    headers_hash
  end

  def get_headers(file)
    CSV.read(file, headers: true, encoding: 'iso-8859-1:utf-8').headers
  end
end

source_dir = File.join(Dir.pwd, 'MaxCases')
source_file = File.join(source_dir, 'dirty_opportunities.csv')
target_file = File.join(source_dir, 'opportunities_companies.csv')

runner = RunnerCompanies.new(source_file, target_file)
runner.execute
