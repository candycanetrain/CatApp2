class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :password, length: {minumum: 6, message: "Password has to be at least 6 characters!"}, allow_nil: true

  attr_reader :password

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(32)
    self.save!
  end

  def password=(password)
    @password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password == BCrypt::Password.new(password)
  end

  def self.find_by_credentials(user_name, password)
    if self.is_password?(password)
      User.find_by(user_name: params[:user_name], password: params[:password])
    end


  end


  private

  def user_params
    params.require(:users).permit(:user_name, :password)
  end
end
