class AddViewedAtToPoi < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE pois ADD column viewed_at TIMESTAMP DEFAULT NOW()'
    execute 'UPDATE pois SET viewed_at = updated_at'
  end

  def self.down
    remove_column :pois, :viewed_at
  end
end
