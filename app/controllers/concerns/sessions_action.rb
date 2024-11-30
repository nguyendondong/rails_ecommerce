module SessionsAction 
  extend ActiveSupport::Concern

  def sign_in(user)
    user.update(remember_token: SecureRandom.urlsafe_base64)
    session[:remember_token] = user.remember_token
  end

  def sign_out
    current_user.update(remember_token: nil)
    session[:remember_token] = nil
  end
end
