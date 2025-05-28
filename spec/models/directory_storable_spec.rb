# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectoryStorable, type: :model do
  describe 'associations' do
    it {
      is_expected.to have_many(:childrens)
        .class_name('Storable')
        .with_foreign_key(:parent_id)
        .inverse_of(:parent)
        .dependent(:destroy)
    }

    it { is_expected.to belong_to(:parent).class_name('DirectoryStorable').optional }
  end

  describe 'inheritance' do
    it 'inherits from Storable' do
      expect(subject).to be_a(Storable)
    end
  end

  it 'does not allow duplicate names in same directory (case insensitive)' do
    parent = create(:directory_storable)
    create(:directory_storable, name: 'MyFolder', parent: parent)
    duplicate = build(:directory_storable, name: 'myfolder', parent: parent)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include('has already been taken')
  end

  it 'raises an error if parent is not a DirectoryStorable' do
    invalid_parent = create(:file_storable)
    expect {
      build(:directory_storable, parent: invalid_parent)
    }.to raise_error(ActiveRecord::AssociationTypeMismatch)
  end

  it 'can have multiple children' do
    parent = create(:directory_storable)
    children = create_list(:directory_storable, 5, parent: parent)

    expect(parent.childrens).to match_array(children)
  end
end
