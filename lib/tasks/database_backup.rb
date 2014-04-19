def database_backup(table_name=nil)
  raw_config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
  database_config = raw_config.to_options! unless raw_config.nil?

  database_name = database_config[:database]
  current_date = DateTime.now.strftime("%Y-%m-%d-%H-%M-%S")

  if table_name.blank?
    backup_path = "#{Rails.root}/tmp/backups/#{database_name}_#{current_date}.sql"

    puts "Dumping to #{backup_path}"
    %x{ mysqldump -u#{database_config[:username]} -p#{database_config[:password]} "#{database_name}" > "#{backup_path}" }
  else
    backup_path = "#{Rails.root}/tmp/backups/#{database_name}_#{table_name}_#{current_date}.sql"

    puts "Dumping to #{backup_path}"
    %x{ mysqldump -u#{database_config[:username]} -p#{database_config[:password]} "#{database_name}" #{table_name} > "#{backup_path}" }
  end

  puts "Zipping #{backup_path}"
  %x{ gzip #{backup_path} }
end

def whole_database_backup
  database_backup
end