FactoryBot.define do
  factory :temp_document, class: Document do
    name "#{FFaker::Name.unique.name}.csv"
    display_name "#{FFaker::Name.name}.csv"
    folder 'public/uploads/temp/'
    file_type '.csv'
    processed false
  end
end
