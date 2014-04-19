#APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/config.yml")[Rails.env]
raw_config = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]
APP_CONFIG = raw_config.to_options! unless raw_config.nil?
f = File.open("#{Rails.root}/config/stop_words.txt")
STOP_WORDS = Array.new
f.each_line do |line|
  STOP_WORDS.push line.strip
end

