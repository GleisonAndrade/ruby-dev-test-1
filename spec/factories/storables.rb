# frozen_string_literal: true

FactoryBot.define do
  factory :storable do
    sequence(:name) { |n| "file_#{n}.txt" }
    association :parent, factory: :directory_storable
  end
end
