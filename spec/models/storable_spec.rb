# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Storable, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:parent).class_name('DirectoryStorable').optional }
  end

  describe 'validations' do
    context 'when name is not present' do
      it 'is invalid' do
        storable = build(:storable, name: nil)
        expect(storable).not_to be_valid
        expect(storable.errors[:name]).to include("can't be blank")
      end
    end

    context 'when name is not unique under the same parent' do
      it 'is invalid' do
        parent = create(:directory_storable)
        create(:storable, name: 'file.txt', parent: parent)
        duplicate = build(:storable, name: 'file.txt', parent: parent)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:name]).to include('has already been taken')
      end
    end

    context 'when name is the same but under different parents' do
      it 'is valid' do
        parent1 = create(:directory_storable)
        parent2 = create(:directory_storable)
        create(:storable, name: 'file.txt', parent: parent1)

        storable = build(:storable, name: 'file.txt', parent: parent2)
        expect(storable).to be_valid
      end
    end

    context 'when parent is a DirectoryStorable' do
      it 'is valid' do
        valid_parent = create(:directory_storable)
        storable = build(:storable, parent: valid_parent)

        expect(storable).to be_valid
      end
    end
  end
end
