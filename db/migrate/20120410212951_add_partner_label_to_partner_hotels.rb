class AddPartnerLabelToPartnerHotels < ActiveRecord::Migration
  def self.up
    add_column :partner_hotels, :partner_label, :string
    execute 'UPDATE partner_hotels SET partner_label = "Agoda" where partner_type = "Agoda"'
    execute 'UPDATE partner_hotels SET partner_label = "HotelsCombined" where partner_type = "HotelsCombined"'
    execute 'UPDATE partner_hotels SET partner_label = "PHRS" where partner_type = "phrs"'
  end

  def self.down
    remove_column :partner_hotels, :partner_label
  end
end
