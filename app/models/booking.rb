class Booking < ActiveRecord::Base
  belongs_to :poi

  validates :first_name, :last_name, :contact_no, :arrival, :poi_id, :presence => true

  validates :email, :presence => true,
                    :length => {:minimum => 3, :maximum => 254},
                    :email => true

  scope :latest, :order => "created_at DESC"

  after_initialize :init

  def init
    self.rooms  ||= 1           #will set the default value only if it's nil
    self.adults  ||= 2           #will set the default value only if it's nil
    self.children ||= 0
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
