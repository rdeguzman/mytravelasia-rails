current_admin = User.find_by_email("rndguzmanjr@yahoo.com")
if not current_admin.blank?
  current_admin.destroy
end

user = User.new
user.email = "rndguzmanjr@yahoo.com"
user.password = "password"
user.password_confirmation = "password"
user.role = "admin"
user.save!

puts "Created Admin"

current_normal = User.find_by_email("rndguzmanjr@gmail.com")
if not current_normal.blank?
  current_normal.destroy
end

user = User.new
user.email = "rndguzmanjr@gmail.com"
user.password = "password"
user.password_confirmation = "password"
user.role = "normal"
user.save!

puts "Created Normal"

current_partner = User.find_by_email("2rmobiledevs@gmail.com")
if not current_partner.blank?
  current_partner.destroy
end

user = User.new
user.email = "2rmobiledevs@gmail.com"
user.password = "password"
user.password_confirmation = "password"
user.role = "partner"
user.first_name = "Rupert"
user.last_name = "De Guzman"
user.mobile_no = "61422515731"
user.address = "2 Birkenhead Ave, Wantirna, Vic"
user.country_id = 103
user.save!

puts "Created Partner"

