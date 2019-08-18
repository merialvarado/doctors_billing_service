class ProcedureType < ApplicationRecord
  belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"

  validates :name, :doctor_id, presence: true
end
