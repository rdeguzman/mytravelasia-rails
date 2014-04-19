class AddDescriptionToPartnerHotel < ActiveRecord::Migration
  def self.up
    add_column :partner_hotels, :description, :text
  end

  def self.down
    remove_column :partner_hotels, :description
  end
end
