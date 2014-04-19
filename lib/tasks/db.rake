namespace :db do
  desc "Backups database based on environment in tmp/backups"
  task :backup => [:environment] do
    whole_database_backup
  end

  desc "Clones database"
  task :clone, [:from, :to] => [:environment] do |t, args|
    args.with_defaults(:from => "development", :to => "test")

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    
    raw_config = YAML.load_file("#{Rails.root}/config/database.yml")
    from_config = raw_config["#{args[:from]}"].to_options! unless raw_config.nil?
    to_config = raw_config["#{args[:to]}"].to_options! unless raw_config.nil?

    current_date = DateTime.now.strftime("%Y-%m-%d-%H-%M-%S")
    backup_path = "#{Rails.root}/tmp/backups/#{from_config[:database]}_#{current_date}.sql"

    puts "Dumping to #{backup_path}"
    %x{ mysqldump -u#{from_config[:username]} -p#{from_config[:password]} "#{from_config[:database]}" > "#{backup_path}" }

    puts "Importing to #{to_config[:database]}"
    %x{ mysql -u#{to_config[:username]} -p#{to_config[:password]} "#{to_config[:database]}" < "#{backup_path}" }
  end


end