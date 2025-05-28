require 'faker'

FactoryBot.define do
  factory :directory_storable do
    name { Faker::File.unique.dir }
    parent { nil }
  end
end
