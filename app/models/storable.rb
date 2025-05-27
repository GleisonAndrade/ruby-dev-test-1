class Storable < ApplicationRecord
  belongs_to :parent, class_name: 'Storable', optional: true
  has_many :childrens, class_name: 'Storable', foreign_key: :parent_id

  validates :name, presence: true
end
