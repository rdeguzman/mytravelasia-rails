class FacebookUser < ActiveRecord::Base
  set_primary_key :profile_id

  validates :profile_id, :uniqueness => true
  validates :first_name, :last_name, :presence => true

  def profile_name
    "#{self.first_name} #{self.last_name[0]}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
