class Hospital < ApplicationRecord
	validates :name, presence: true

	has_many :patients
end
