# Override your default settings for the Development environment here.
# 
# Example:
#   configatron.file.storage = :local
Rails.root,APN::App::Rails.env = Rails.env

# development (delivery):
#configatron.apn.passphrase # => ''
configatron.apn.port  = 2195
configatron.apn.host  = 'gateway.sandbox.push.apple.com'
configatron.apn.cert = File.join(Rails.root, 'config', 'apple_push_notification_development.pem')

# development (feedback):
#configatron.apn.feedback.passphrase # => ''
configatron.apn.feedback.port = 2196
configatron.apn.feedback.host = 'feedback.sandbox.push.apple.com'
configatron.apn.feedback.cert = File.join(Rails.root, 'config', 'apple_push_notification_development.pem')
