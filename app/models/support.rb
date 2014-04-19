class Support < ActiveRecord::Base
  validates :name, :contact, :description, :presence => true
  validates :email, :presence => true,
                    :length => {:minimum => 3, :maximum => 254},
                    :email => true

  scope :latest, :order => "created_at DESC"
end
