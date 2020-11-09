# Load the Rails application.
require_relative 'application'

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: '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',
  domain: 'localhost',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

# Initialize the Rails application.
Rails.application.initialize!
