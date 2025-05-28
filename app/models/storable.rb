# frozen_string_literal: true

class Storable < ApplicationRecord
  belongs_to :parent, class_name: 'DirectoryStorable', optional: true

  validate :parent_must_be_directory_storable, if: -> { parent.present? }

  validates :name, presence: true, uniqueness: { scope: :parent_id, case_sensitive: false }

  private

  def parent_must_be_directory_storable
    unless parent.is_a?(DirectoryStorable)
      errors.add(:parent, 'must be a DirectoryStorable')
    end
  end
end
