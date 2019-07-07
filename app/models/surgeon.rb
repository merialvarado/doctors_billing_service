class Surgeon < ApplicationRecord
  validates :full_name, presence: true
end
