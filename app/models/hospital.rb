class Hospital < ApplicationRecord
	validates :name, :address, :contact_num, presence: true

	has_many :patients
end
