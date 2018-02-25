# CvsUtil for common csv operations
module CsvUtil
  DEFAULT_ENCODING = 'iso-8859-1:utf-8'.freeze

  def iterate_csv(csv_path)
    options = { headers: true, encoding: DEFAULT_ENCODING }
    CSV.foreach(csv_path, options) do |on|
      yield(on)
    end
  end

  def write_csv(csv_path)
    options = { encoding: DEFAULT_ENCODING }
    CSV.open(csv_path, 'wb', options) do |on|
      yield(on)
    end
  end

  def get_headers(csv_path)
    CSV.read(csv_path, headers: true, encoding: DEFAULT_ENCODING).headers
  end
end
