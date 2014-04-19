class PoiType < ActiveRecord::Base
  validates :poi_type_name, :presence => true, :uniqueness => true

  def name
    self.poi_type_name
  end
end
