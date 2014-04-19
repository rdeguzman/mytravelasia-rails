class DropPoiBackup < ActiveRecord::Migration
  def self.up
    execute 'DROP TABLE IF EXISTS poi_backups'
  end

  def self.down
  end
end
