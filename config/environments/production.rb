Bindlink::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.assets.precompile += %w( *.css *.js )

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
   config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  # AMAZON SES mailer configuration
 # config.action_mailer.delivery_method = :smtp
 # config.action_mailer.smtp_settings = {
 #     :address => "email-smtp.us-east-1.amazonaws.com",
 #     :user_name => "AKIAJOCB2KNBTBQ5IL5A",
 #     :password => "AvmAp6XOAA7fO8sCIqyWB+9PDWmHb+5Qy00ogTcbHxG6",
 #     :authentication => :login,
 #     :enable_starttls_auto => true
 # }

  #Mailgun mailer configuration
  #config.action_mailer.delivery_method = :smtp
#config.action_mailer.default_charset = "utf-8"
#config.action_mailer.perform_deliveries = true
#config.action_mailer.raise_delivery_errors = true
=begin
  config.action_mailer.smtp_settings = {
     :authentication => :plain,
     :address => "smtp.mailgun.org",
     :port => 587,
     :domain => "bindlink.mailgun.org",
     :user_name => "postmaster@bindlink.mailgun.org",
     :password => "508g5slmxo95"
}
=end

  #devise mailer
  config.action_mailer.default_url_options = { :host => 'bindlink.com' }

  # AMAZON SES mailer configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address => "email-smtp.us-east-1.amazonaws.com",
      :user_name => "AKIAJC2WNUMVQRM6X74A",
      :password => "Ajy2b8I0G1oio6O7gcXQEsojQPItW9dlKvWFEBaUbOqc",
      :authentication => :login,
      :enable_starttls_auto => true,
      :port => 587
  }

  config.action_mailer.default_url_options = { :host => 'https://stark-winter-3173.herokuapp.com/' }

  config.fslsourl = 'http://slip.fslso.com/webservice/fslsobatchfiling.asmx'

end