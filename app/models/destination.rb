class Destination < ActiveRecord::Base
  attr_accessible :id, :destination_name, :description, :country_id, :destination_type_id, :longitude, :latitude, :top
  
  belongs_to :country
  belongs_to :destination_type
  
  has_many :pois, :dependent => :destroy
   
  has_many :descriptions, :foreign_key => 'parent_id', :conditions => "table_name = 'destination'"
  
  #Don't use validates_associated, instead use 'presence' and explicitly specify @destination.country_id = params[destination][country_id] 
  validates :country, :presence => true
  validates :destination_type, :presence => true

  validates :destination_name, :presence => true, :uniqueness => { :scope => [:country_id, :destination_type_id] }

  scope :top_most, where("destinations.total_pois > ?",
                         APP_CONFIG[:top_destination_count]).includes(:country)


  scope :top_destinations_for_country, where("destinations.total_pois > ?",
                                             APP_CONFIG[:country_top_destination_count]).includes(:country)


  scope :top_limited_destinations_with_pois, where("destinations.total_pois > 10").includes(:country)
  scope :top_destinations_with_pois, where("destinations.total_pois > 0").includes(:country)

  scope :alphabetically, :order => "destination_name ASC"

  def to_param
    "#{id}-#{destination_name.gsub(/\s/, '-').gsub(/[^0-9A-Za-z\-]/, '')}"
  end
  
  def name
    self.destination_name
  end

  def update_totals
    self.total_pois = self.pois.count
    self.total_attractions = self.pois.attraction.count
    self.total_hotels = self.pois.hotel.count
    self.save
  end
  
end
