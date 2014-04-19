class CreateFacebookUsers < ActiveRecord::Migration
  def self.up
    create_table :facebook_users, :id => false do |t|
      t.integer :profile_id, :limit => 8
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_users
  end
end
