class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.integer :partner_hotel_id
      t.integer :hotel_id
      t.string :partner_type
      t.string :room_type
      t.integer :occupancy, :default => 0
      t.float :rate
      t.string :currency_code
      t.date :date_from
      t.date :date_to
      t.text :meals
      t.text :cancellation_policy
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
