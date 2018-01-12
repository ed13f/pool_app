class Repair < ApplicationRecord
	has_many :images
  	belongs_to :customer
  	has_one :user, through: :customer, source: :user
end
