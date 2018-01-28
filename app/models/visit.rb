class Visit < ApplicationRecord
	belongs_to :user
  	belongs_to :customer
    validates :ph, :presence => true
end
