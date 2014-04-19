class AddContactToBooking < ActiveRecord::Migration
  def self.up
    add_column :bookings, :poi_id, :integer
    add_column :bookings, :first_name, :string
    add_column :bookings, :last_name, :string
    add_column :bookings, :contact_no, :string
    add_column :bookings, :email, :string
    add_column :bookings, :children, :integer
    add_column :bookings, :comment, :text
    add_column :bookings, :arrival, :date
    add_column :bookings, :departure, :date
  end

  def self.down
    remove_column :bookings, :poi_id
    remove_column :bookings, :first_name
    remove_column :bookings, :last_name
    remove_column :bookings, :contact_no
    remove_column :bookings, :email
    remove_column :bookings, :children
    remove_column :bookings, :comment
    remove_column :bookings, :arrival
    remove_column :bookings, :departure
  end
end
