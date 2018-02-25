require 'rails_helper'

RSpec.describe LookupCsv::LookupCsvGenerator do
  let(:target_data) do
    [
      %w[Id Name CategoryName],
      ['1', 'Product 1', 'Category 10'],
      ['2', 'Product 2', 'Category 1'],
      ['3', 'Product 3', 'Category 3'],
      ['4', 'Product 4', 'Category 1'],
      ['5', 'Product 5', 'Category 2'],
      ['6', 'Product 6', 'Category 2'],
      ['7', 'Product 7', 'Category 5'],
      ['8', 'Product 8', 'Category 1'],
      ['9', 'Product 9', 'Category 4'],
      ['10', 'Product 10', 'Category 3']
    ]
  end
  let(:source_data) do
    [
      %w[Id Name],
      ['1', 'Category 1'],
      ['2', 'Category 2'],
      ['3', 'Category 3'],
      ['4', 'Category 4'],
      ['5', 'Category 5']
    ]
  end
  let(:target_file_name) { 'target.csv' }
  let(:source_file_name) { 'source.csv' }
  let(:target_csv) do
    file_path = "public/test_files/#{target_file_name}"
    CSV.open(file_path, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      target_data.each do |data|
        row << data
      end
    end
    file_path
  end
  let(:source_csv) do
    file_path = "public/test_files/#{source_file_name}"
    CSV.open(file_path, 'wb', encoding: 'iso-8859-1:utf-8') do |row|
      source_data.each do |data|
        row << data
      end
    end
    file_path
  end
  let(:target_document) do
    create(:temp_document, name: target_file_name, folder: 'public/test_files/')
  end
  let(:source_document) do
    create(:temp_document, name: source_file_name, folder: 'public/test_files/')
  end
  let(:lookup_result) do
    [
      ['1', 'Product 1', 'Category 10', nil],
      ['2', 'Product 2', 'Category 1', '1'],
      ['3', 'Product 3', 'Category 3', '3'],
      ['4', 'Product 4', 'Category 1', '1'],
      ['5', 'Product 5', 'Category 2', '2'],
      ['6', 'Product 6', 'Category 2', '2'],
      ['7', 'Product 7', 'Category 5', '5'],
      ['8', 'Product 8', 'Category 1', '1'],
      ['9', 'Product 9', 'Category 4', '4'],
      ['10', 'Product 10', 'Category 3', '3']
    ]
  end

  it 'test dependency' do
    target_csv
    source_csv
    csv_file = LookupCsv::LookupCsvGenerator.new(
      target_document,
      source_document,
      'CategoryName',
      'Name',
      'Id'
    )
    document = csv_file.call
    c = 0
    CSV.foreach(document.full_path, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      expect(row.values_at).to eq(lookup_result[c])
      c += 1
    end
    document.destroy
  end
end
