class Like < ActiveRecord::Base
  belongs_to :poi

  validates_uniqueness_of :profile_id, :scope => :poi_id
end
