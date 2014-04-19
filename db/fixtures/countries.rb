lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Country.seed do |c|
  c.id    = 200
  c.country_name = "PhilippineTest"
  c.description = "Philippines is made up 7107 Islands #{lorem_ipsum}"
end

Country.seed do |c|
  c.id    = 201
  c.country_name = "CountryTestForDelete"
  c.description = "TechHub of Asia #{lorem_ipsum}"
end