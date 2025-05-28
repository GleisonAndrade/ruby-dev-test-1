# frozen_string_literal: true

class FileStorable < Storable
  has_one_attached :file

  validates :parent, presence: true
  validate :file_must_be_attached

  private

  def file_must_be_attached
    errors.add(:file, 'must be attached') unless file.attached?
  end
end
