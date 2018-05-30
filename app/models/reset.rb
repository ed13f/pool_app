class Reset < ApplicationRecord
  belongs_to :user, optional: true

  validates :email, :presence => true
  validates :temp_pass, :presence => true
  validates :person_id_num, :presence => true
  validates :reset_type, :presence => true
end
