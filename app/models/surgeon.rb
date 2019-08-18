class Surgeon < ApplicationRecord
  belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"

  validates :full_name, :doctor_id, presence: true
end
