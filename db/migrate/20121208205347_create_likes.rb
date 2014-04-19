class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.integer :profile_id, :limit => 8
      t.integer :poi_id
      t.timestamps
    end
  end

  def self.down
    drop_table :likes
  end
end
