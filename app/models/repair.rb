class Repair < ApplicationRecord
	has_many :images, dependent: :destroy
	belongs_to :customer
	has_one :user, through: :customer, source: :user

  validates :title, :presence => true
  validates :customer_id, :presence => true
  validates :description, :presence => true

	def print_date
		self.created_at.strftime("%m/%d/%Y")
	end	

	def print_updated_date
		self.updated_at.strftime("%m/%d/%Y")
	end	

end
