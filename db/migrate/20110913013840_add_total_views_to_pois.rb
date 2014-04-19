class AddTotalViewsToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :total_views, :integer, :default => 0
  end

  def self.down
    remove_column :pois, :total_views
  end
end