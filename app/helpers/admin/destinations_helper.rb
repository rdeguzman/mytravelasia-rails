module Admin::DestinationsHelper
  def country_name(country = nil)
    if country != nil
      country.country_name
    end
  end
end
