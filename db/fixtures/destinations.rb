lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Destination.seed do |d|
  d.id    = 1
  d.destination_name = "ManilaTest"
  d.country_id = 200
  d.description = "Capital of Philippines #{lorem_ipsum}"
  d.destination_type_id = 2
  d.longitude = 120.976160000000
  d.latitude = 14.601033000000
end

Destination.seed do |d|
  d.id    = 2
  d.destination_name = "BoracayTest"
  d.country_id = 200
  d.description = "Beach Island with good nightlife #{lorem_ipsum}"
  d.destination_type_id = 5
  d.longitude = 121.927400000000
  d.latitude = 11.971839000000
end

Destination.seed do |d|
  d.id    = 3
  d.destination_name = "CebuTest"
  d.country_id = 200
  d.description = "Cebuanos is famous for their lechon. #{lorem_ipsum}"
  d.destination_type_id = 2
  d.longitude = 123.896933000000
  d.latitude = 10.345562000000
end

Destination.seed do |d|
  d.id    = 4
  d.destination_name = "Manila-Destination-Test"
  d.country_id = 200
  d.description = "This destination is for deleting. Dont add any poi into this. #{lorem_ipsum}"
  d.destination_type_id = 1
  d.longitude = 121.927400000000
  d.latitude = 11.971839000000
end