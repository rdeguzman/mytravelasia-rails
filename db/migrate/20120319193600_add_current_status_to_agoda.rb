class AddCurrentStatusToAgoda < ActiveRecord::Migration
  def self.up
    add_column :agodas, :current_status, :string, :default => 'new'
  end

  def self.down
    remove_column :agodas, :current_status
  end
end
