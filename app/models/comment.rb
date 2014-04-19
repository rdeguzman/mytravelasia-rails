class Comment < ActiveRecord::Base
  belongs_to :facebook_user, :foreign_key => :profile_id
  belongs_to :poi
  validates :content, :poi_id, :profile_id, :presence => true
end
