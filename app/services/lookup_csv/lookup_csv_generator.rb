# LookupCsv

module LookupCsv
  # LookupCsvGenerator
  class LookupCsvGenerator
    include CsvUtil
    DEFAULT_FOLDER = Rails.root.join('public', 'downloads')

    def initialize(target, source, target_header, source_header_comparer, source_header_value)
      @target = target
      @source = source
      @target_header = target_header
      @source_header_comparer = source_header_comparer
      @source_header_value = source_header_value
    end

    def call
      target_headers = get_headers(@target.full_path)
      lookup_hash = get_lookup_hash(@source.full_path, @source_header_comparer, @source_header_value)
      output = []
      write_lookup(@target.full_path, @target_header, lookup_hash, output)
      headers = target_headers << 'LookupValue'
      process_files(@target, @source)
      write_in_file(DEFAULT_FOLDER, output, headers)
    end

    private

    def get_lookup_hash(path, key, value)
      lookup_hash = {}
      iterate_csv(path) do |row|
        lookup_hash[row[key]] = row[value]
      end
      lookup_hash
    end

    def write_lookup(path, find_header, lookup_hash, output_array)
      iterate_csv(path) do |row|
        find_value = row[find_header] || ''
        row << { :'"LookupValue"' => lookup_hash[find_value] }
        output_array << row
      end
      output_array
    end

    def process_files(*args)
      args.each do |document|
        Document.update(document.id, processed: true)
      end
    end

    def write_in_file(path, array_data, headers)
      file_name = SecureRandom.urlsafe_base64 + '.csv'
      full_path = path + file_name
      write_csv(full_path) do |row|
        row << headers
        array_data.each do |data|
          row << data
        end
      end
      save_document(file_name, path)
    end

    def save_document(file_name, path)
      document = Document.new(name: file_name, display_name: 'LookupCSV.csv', folder: path, file_type: 'csv')
      document.save
      document
    end
  end
end
