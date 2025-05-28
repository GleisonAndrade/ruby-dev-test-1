# frozen_string_literal: true

class DirectoryStorable < Storable
  has_many :childrens, class_name: 'Storable', foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
end
