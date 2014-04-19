class OptimizePartnerHotels < ActiveRecord::Migration
  def self.up
    remove_column :partner_hotels, :hotel_file_name
    remove_column :partner_hotels, :rating
    remove_column :partner_hotels, :address
    remove_column :partner_hotels, :image_file_name
    remove_column :partner_hotels, :number_of_reviews
    remove_column :partner_hotels, :consumer_rating
    remove_column :partner_hotels, :property_type_id
    remove_column :partner_hotels, :chain_id
    remove_column :partner_hotels, :facility_list_id
    remove_column :partner_hotels, :folder_name
    remove_column :partner_hotels, :file_name
    remove_column :partner_hotels, :check_in
    remove_column :partner_hotels, :check_out
  end

  def self.down
  end
end
