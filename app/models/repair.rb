class Repair < ApplicationRecord
	has_many :images
	belongs_to :customer
	has_one :user, through: :customer, source: :user

  validates :title, :presence => true
  validates :customer_id, :presence => true
  validates :description, :presence => true
end
