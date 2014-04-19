class RenameParentIdToPoiIdForWebPhotos < ActiveRecord::Migration
  def self.up
    remove_index :web_photos, :parent_id
    rename_column :web_photos, :parent_id, :poi_id
    add_index :web_photos, :poi_id
    remove_column :web_photos, :table_name
  end

  def self.down
    add_column :web_photos, :table_name, :string, :default => "poi"
    rename_column :web_photos, :poi_id, :parent_id
  end
end
