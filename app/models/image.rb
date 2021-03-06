class Image < ApplicationRecord
	belongs_to :repair
  	has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  	validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  	validates :photo, :presence => true
end
