class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.string :destination_name
      t.text :description
      t.integer :parent_id
      t.references :destination_type
      t.references :country
      t.decimal :longitude, :precision => 12, :scale => 8
      t.decimal :latitude, :precision => 12, :scale => 8
      t.timestamps
    end
  end

  def self.down
    drop_table :destinations
  end
end
