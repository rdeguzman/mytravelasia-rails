class AddLikesToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :total_likes, :integer, :default => 0
  end

  def self.down
    remove_column :pois, :total_likes
  end
end
