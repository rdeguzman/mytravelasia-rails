class AddMoreFieldsToPartnerHotel < ActiveRecord::Migration
  def self.up
    add_column :partner_hotels, :hotel_id, :integer
    add_column :partner_hotels, :partner_type, :string
    add_column :partner_hotels, :web_partner_url, :text
    add_column :partner_hotels, :mobile_partner_url, :text
  end

  def self.down
    remove_column :partner_hotels, :hotel_id
    remove_column :partner_hotels, :partner_type
    remove_column :partner_hotels, :web_partner_url
    remove_column :partner_hotels, :mobile_partner_url
  end
end
