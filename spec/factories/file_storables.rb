FactoryBot.define do
  factory :file_storable do
    name { Faker::File.unique.file_name }
    parent { association(:directory_storable) }

    after(:build) do |file_storable|
      file_storable.file.attach(
        io: StringIO.new("example content"),
        filename: "example.txt",
        content_type: "text/plain"
      )
    end
  end
end
