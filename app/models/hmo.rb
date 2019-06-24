class Hmo < ApplicationRecord
	has_many :patients

  def total_balance_amount
    self.patients.sum(:balance)
  end
end
