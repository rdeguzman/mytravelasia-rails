class AddNameContactToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :mobile_no, :string
    add_column :users, :tel_no, :string
    add_column :users, :fax_no, :string
    add_column :users, :address, :string
    add_column :users, :country_id, :integer
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :mobile_no
    remove_column :users, :tel_no
    remove_column :users, :fax_no
    remove_column :users, :address
    remove_column :users, :country_id
  end
end
