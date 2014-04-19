class AddCurrentStatusToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :current_status, :string, :default => 'new'
    execute('UPDATE pois SET current_status = "approved"')
  end

  def self.down
    remove_column :pois, :current_status
  end
end

