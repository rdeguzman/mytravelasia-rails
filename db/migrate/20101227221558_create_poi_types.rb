class CreatePoiTypes < ActiveRecord::Migration
  def self.up
    create_table :poi_types do |t|
      t.string :poi_type_name
      t.timestamps
    end
  end

  def self.down
    drop_table :poi_types
  end
end
