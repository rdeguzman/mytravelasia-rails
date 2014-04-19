class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.integer :profile_id, :limit => 8
      t.integer :poi_id
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
