<VirtualHost 173.255.249.114:80>
	ServerAdmin rupert@2rmobile.com
	ServerName mytravel-asia.com
	ServerAlias www.mytravel-asia.com

  PassengerRuby /home/rupert/.rvm/wrappers/ruby-1.9.2-p180/ruby
	DocumentRoot /srv/rails/mytravel-asia/current/public
	ErrorLog /var/log/apache2/mytravel-asia.com-error.log

	LogLevel warn
	CustomLog /var/log/apache2/mytravel-asia.com-access.log combined

  #If it finds a system/maintenance.html file then it will show that.
  <IfModule mod_rewrite.c>
    RewriteEngine On

    # Redirect all requests to the maintenance page if present
    RewriteCond %{REQUEST_URI} !\.(css|gif|jpg|png)$
    RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
    RewriteCond %{SCRIPT_FILENAME} !maintenance.html
    RewriteRule ^.*$ /system/maintenance.html [L]
  </IfModule>

</VirtualHost>
