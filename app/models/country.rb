class Country < ActiveRecord::Base
  attr_accessible :country_name, :country_code, :description

  has_many :descriptions, :foreign_key => 'parent_id', :conditions => "table_name = 'country'"
  
  has_many :pois, :dependent => :destroy
  has_many :destinations, :dependent => :destroy

  validates :country_name, :presence => true, :uniqueness => true

  scope :alphabetically, :order => "country_name"
  
  def to_param
    "#{id}-#{country_name.gsub(/\s/, '-').gsub(/[^0-9A-Za-z\-]/, '')}"
  end
  
  def name
    self.country_name
  end

  def update_totals
    self.total_destinations = self.destinations.count
    self.total_pois = self.pois.count
    self.save
  end
  
end
