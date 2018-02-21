require 'csv'

# ReaderCsv
class ReaderCsv
  def initialize(csv_file)
    @csv_file = csv_file
  end

  def execute
    CSV.foreach(@csv_file, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      logger.debug "row: #{row}"
      break
    end
  end
end

source_file = File.join(Dir.pwd, 'MaxCases', 'dirty_opportunities.csv')
reader = ReaderCsv.new(source_file)
reader.execute
