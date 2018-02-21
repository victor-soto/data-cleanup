require 'csv'
load 'app/scripts/max_cases/csv_util.rb'

# RunnerProducts
class RunnerProducts
  include ::CSVUtil

  def initialize(csv_source, csv_output)
    @csv_source = csv_source
    @csv_output = csv_output
  end

  def execute
    headers = get_headers(@csv_source)
    hash_headers = headers_to_hash(headers)
    dict_rows = {}

    read_data(@csv_source, hash_headers, dict_rows)
    write_data(@csv_output, dict_rows)
  end

  private

  def read_data(csv_file, hash_headers, dict_rows)
    CSV.foreach(csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      products = split_products(row, hash_headers)
      if products != ''
        products.each do
          dict_rows[row[hash_headers['id']]] = { 'products' => products.map(&:lstrip) }
        end
      end
    end
  end

  def write_data(csv_file, dict_rows)
    CSV.open(csv_file, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      row << %w[id product price quantity]
      dict_rows.each do |hash_content|
        next if hash_content['products'].nil? do
          row_content = push_cel
          fill_product(hash_content, row, row_content)
        end
      end
    end
  end

  def fill_products_data(idx, row_content, product_data)
    row_content.push(product(idx, product_data))
    row_content.push(price(idx, product_data))
    row_content.push(quantity(idx, product_data))
  end

  def split_products(row, hash_headers)
    !row[hash_headers['products']].nil? ? row[hash_headers['products']].split(',') : ''
  end

  def get_price(product_extract)
    price_str = product_extract.split('x')[0]
    price_str[1..price_str.length - 1]
  end

  def get_quantity(product_extract)
    price_str = product_extract.split('x')[1]
    price_str[0..price_str.length - 2]
  end

  def push_cel
    row_content = []
    row_content.push(key)
  end

  def fill_product(hash_content, row, row_content)
    hash_content['products'].each do |product_data|
      fill_products_data(product_data.index('$'), push_cel, product_data)
      row << row_content
    end
  end

  def product(idx, product_data)
    !idx.nil? ? product_data[0..idx - 2] : product_data
  end

  def price(idx, product_data)
    !idx.nil? ? get_price(product_data[idx - 1..product_data.length - 1]) : 0
  end

  def quantity(idx, product_data)
    !idx.nil? ? get_quantity(product_data[idx - 1..product_data.length - 1]) : 0
  end
end

source = File.join(File.dirname(__FILE__), 'update_spreadsheet.csv')
target = File.join(File.dirname(__FILE__), 'opportunities_products.csv')

runner = RunnerProducts.new(source, target)
runner.execute
