

class User < ActiveRecord::Base
  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, message: "Password has to be at least 6 characters!"}, allow_nil: true

  attr_reader :password
  after_initialize :ensure_session_token

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(32)
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    @user = User.find_by(user_name: user_name)
    if @user && @user.is_password?(password)
      @user
    else
      nil
      # flash[:notice] = "Invalid Credentials!!!"
    end
  end


  private
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(32)
  end
end
