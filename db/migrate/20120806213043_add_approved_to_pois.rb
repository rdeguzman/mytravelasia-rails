class AddApprovedToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :approved, :boolean, :default => false
    execute "UPDATE pois SET approved = true;"
  end

  def self.down
    remove_column :pois, :approved
  end
end
