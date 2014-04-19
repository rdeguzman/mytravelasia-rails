class AddPoiIdToAgoda < ActiveRecord::Migration
  def self.up
    add_column :agodas, :poi_id, :integer
  end

  def self.down
    remove_column :agodas, :poi_id
  end
end
