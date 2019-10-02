class User < ApplicationRecord
	has_many :visits
	has_many :customers
	has_many :routes
	has_many :customer_visits, through: :visits, source: :customer
	belongs_to :business
  has_many :repairs, through: :business, source: :repairs
  has_secure_password

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true, :length => { :minimum => 10, :maximum => 10 }
  validates :email, :presence => true, format: /\w+@\w+\.{1}[a-zA-Z]{2,}/
  validates :password_digest, :presence => true
  validates :business_id, :presence => true

	def full_name
  	self.first_name + " " + self.last_name
	end

  def finished_pools
    # binding.pry

    # scheduled_days = self.customers.select do |customer|
    #   customer.days.days_list.count < 0
    # end
    # scheduled_days
  end 
  # def self.search_pools(user)
  #       search = params[:search]
  #       if search
  #         @pools = user.customers
  #         @pools = @pools.where("first_name LIKE ? OR last_name LIKE ?", "%#{search}%", "%#{search}%")
  #       else
  #         @pools = user.customers
  #       end
  # end
end
