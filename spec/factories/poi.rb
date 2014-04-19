FactoryGirl.define do

  factory :poi do

    address "123 Rizal Ave, Manila"
    description "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum "

    country Country.find_by_country_name("Philippines")
    destination Destination.find_by_destination_name("Manila")

    longitude 121.23525
    latitude 14.5724

    factory :attraction do
      poi_type PoiType.find_by_poi_type_name("Attraction")
      name "TestAttraction"
    end

    factory :hotel do
      poi_type PoiType.find_by_poi_type_name("Hotel")
      name "TestHotel"
    end

  end

end