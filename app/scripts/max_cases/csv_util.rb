# CSVUtil
module CSVUtil
  def get_headers(file)
    CSV.read(file, headers: true, encoding: 'iso-8859-1:utf-8').headers
  end

  def headers_to_hash(headers)
    headers_hash = {}
    headers.each_with_index do |header, index|
      headers_hash[header] = index
    end
    headers_hash
  end
end
