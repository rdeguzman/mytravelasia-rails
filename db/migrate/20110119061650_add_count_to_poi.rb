class AddCountToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :picture_thumb_path, :string
    add_column :pois, :picture_full_path, :string
    add_column :pois, :total_pictures, :integer, :default => 0
    add_column :pois, :min_rate, :string, :default => 0
    add_column :pois, :currency_code, :string
  end

  def self.down
    remove_column :pois, :picture_thumb_path
    remove_column :pois, :picture_full_path
    remove_column :pois, :total_pictures
    remove_column :pois, :min_rate
    remove_column :pois, :currency_code
  end
end
