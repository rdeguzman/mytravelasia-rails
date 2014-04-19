class PoiUserPrivilege < ActiveRecord::Base
  belongs_to :user
  belongs_to :poi

  validates :user_id, :presence => true
  validates :poi_id, :presence => true

  scope :latest, :order => "created_at DESC"
end