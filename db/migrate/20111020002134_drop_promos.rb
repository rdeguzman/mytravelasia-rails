class DropPromos < ActiveRecord::Migration
  def self.up
    execute 'DROP TABLE IF EXISTS promos'
  end

  def self.down
  end
end
