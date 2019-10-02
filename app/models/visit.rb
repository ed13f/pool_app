class Visit < ApplicationRecord
	belongs_to :user
  	belongs_to :customer

    # validates :ph, :presence => true
    # validates :alkalinity, :presence => true
    validates :user_id, :presence => true
    validates :customer_id, :presence => true
end
