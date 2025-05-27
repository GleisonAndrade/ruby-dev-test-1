require 'rails_helper'

RSpec.describe Storable, type: :model do
  it { should validate_presence_of(:name) }
  it { should belong_to(:parent).class_name('Storable').optional }
  it { should have_many(:childrens).class_name('Storable').with_foreign_key(:parent_id).dependent(:destroy) }
end
