require 'rails_helper'

RSpec.describe FileStorable, type: :model do
  describe 'inheritance' do
    it 'inherits from Storable' do
      expect(subject).to be_a(Storable)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:parent).class_name('DirectoryStorable').optional }
    it { is_expected.to have_one_attached(:file) }
  end

  describe 'validations' do
    let(:directory) { create(:directory_storable) }

    it 'is invalid without a parent' do
      file_storable = build(:file_storable, parent: nil)
      expect(file_storable).not_to be_valid
      expect(file_storable.errors[:parent]).to include("can't be blank")
    end

    it 'is invalid without an attached file' do
      file_storable = build(:file_storable)
      file_storable.file.detach
      expect(file_storable).not_to be_valid
      expect(file_storable.errors[:file]).to include("must be attached")
    end

    it 'is valid with a parent and attached file' do
      file = build(:file_storable)
      expect(file).to be_valid
    end
  end
end
