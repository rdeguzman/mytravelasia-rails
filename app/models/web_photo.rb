class WebPhoto < ActiveRecord::Base
  belongs_to :user
  belongs_to :poi

  validates_uniqueness_of :thumb_path, :full_path
end
