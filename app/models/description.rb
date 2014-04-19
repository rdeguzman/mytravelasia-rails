class Description < ActiveRecord::Base
  attr_accessible :content, :parent_id, :table_name, :description_type_id
  
  belongs_to :description_type
  
  validates :description_type, :presence => true
  validates :content, :presence => true
  validates :parent_id, :presence => true
  validates :table_name, :presence => true
end
