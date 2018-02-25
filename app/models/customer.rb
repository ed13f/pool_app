class Customer < ApplicationRecord
	belongs_to :user
  has_many :visits, dependent: :destroy
  has_many :repairs, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :days, dependent: :destroy
  has_one :business, through: :user, source: :business
  accepts_nested_attributes_for :days, allow_destroy: true, reject_if: :all_blank

  	geocoded_by :full_address
  	after_validation :geocode

  	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :phone, :presence => true
    validates :email, :presence => true
    validates :street_address, :presence => true
    validates :city, :presence => true
    validates :state, :presence => true
    validates :zip_code, :presence => true

  	def full_name
    	self.first_name + " " + self.last_name
  	end

  	def reset_pool_completion
    	pools = Customer.all
      		pools.each do |pool|
        	pool.weekly_complete = false
        	pool.save
    	end
  	end

  	# def coordinates
  	#   coord_obj = {latitude: self.latitude, longitude: self.longitude}
  	#   puts "coordinates-rico"
  	#   coord_obj
  	# end

  	def full_address
    	self.street_address + " " + self.city + ", " + self.state + " " + self.zip_code
  	end

    def short_address
      self.street_address + " " + self.city + ", " + self.state
    end

    def address_street_city
      self.street_address + ", " + self.city
    end 

    def days_list
    list = []
    if self.monday
      list.push("Monday")
    end
    if self.tuesday
      list.push("Tuesday")
    end
    if self.wednesday
      list.push("Wednesday")
    end
    if self.thursday
      list.push("Thursday")
    end
    if self.friday
      list.push("Saturday")
    end
    list
  end

  def days_visited_list
    self.weekly_visit_str.split
  end

  def print_days
    day_string = self.days_list.join(" ")
  end
end
