# Override your default settings for the Production environment here.
# 
# Example:
#   configatron.file.storage = :s3
Rails.root,APN::App::Rails.env = Rails.env

# production (delivery):
configatron.apn.port  = 2195
configatron.apn.host = 'gateway.push.apple.com'
configatron.apn.cert = File.join(Rails.root, 'config', 'apple_push_notification_production.pem')

# production (feedback):
configatron.apn.feedback.port = 2196
configatron.apn.feedback.host = 'feedback.push.apple.com'
configatron.apn.feedback.cert = File.join(Rails.root, 'config', 'apple_push_notification_production.pem')