class Note < ApplicationRecord
	belongs_to :customer
  	has_one :user, through: :customer, source: :user
end
