Devise.setup do |config|
  config.mailer_sender = Settings.mailer.from

  require "devise/orm/active_record"

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : Settings.devise.cost

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = Settings.devise.email

  config.lock_strategy = :failed_attempts

  config.unlock_keys = [:time]

  config.unlock_strategy = :time

  config.maximum_attempts = Settings.devise.maximum_attempts

  config.unlock_in = 30.minutes

  config.last_attempt_warning = true

  config.sign_out_via = :delete

  config.reset_password_within = 4.hours

  config.reconfirmable = true
  config.allow_unconfirmed_access_for = 4.hours
  config.confirm_within = 4.hours

  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
