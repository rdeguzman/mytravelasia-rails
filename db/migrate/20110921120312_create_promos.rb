class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :title
      t.text :description
      t.text :fine_print
      t.integer :poi_id
      t.integer :country_id
      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
