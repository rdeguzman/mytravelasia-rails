class CreateWebPhotos < ActiveRecord::Migration
  def self.up
    create_table :web_photos do |t|
      t.string :caption_title
      t.text :caption_description
      t.string :credits_to
      t.string :credits_url
      t.string  :thumb_path
      t.string :full_path
      t.integer :parent_id
      t.string :table_name
      t.references :user
      
      t.timestamps
    end
  end

  def self.down
    drop_table :web_photos
  end
end
