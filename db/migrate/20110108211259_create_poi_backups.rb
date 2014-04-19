class CreatePoiBackups < ActiveRecord::Migration
  def self.up
    create_table :poi_backups do |t|
      t.string :name
      t.string :location_address
      t.string :description_brief
      t.text :description_long
      t.text :get_there
      t.string :poi_url
      t.string :tel_no
      t.string  :atype
      t.string :city
      t.string :province
      t.decimal :longitude, :precision => 12, :scale => 8
      t.decimal :latitude, :precision => 12, :scale => 8
      t.string :fax_no
      t.string :email
      t.float :total_stars, :default => 0
      t.integer :total_ratings, :default => 0
      t.integer :destination_id
      t.string :destination_name
      t.integer :partner_hotel_id
      t.string :update_remarks
      t.integer :update_user_id
      t.string :update_user_name
      t.timestamps
    end
  end

  def self.down
    drop_table :poi_backups
  end
end
