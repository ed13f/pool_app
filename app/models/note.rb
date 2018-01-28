class Note < ApplicationRecord
	belongs_to :customer
  	has_one :user, through: :customer, source: :user

    validates :description, :presence => true
    validates :customer_id, :presence => true
end
