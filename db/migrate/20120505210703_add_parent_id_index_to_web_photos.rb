class AddParentIdIndexToWebPhotos < ActiveRecord::Migration
  def self.up
    add_index :web_photos, :parent_id
  end

  def self.down
    remove_index :web_photos, :parent_id
  end
end
