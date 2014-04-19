class Room < ActiveRecord::Base
  belongs_to :partner_hotel
  attr_accessor :partner_url
end
