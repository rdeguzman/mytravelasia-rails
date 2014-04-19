class AddBookingEmailToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :booking_email_providers, :string
  end

  def self.down
    remove_column :pois, :booking_email_providers
  end
end
