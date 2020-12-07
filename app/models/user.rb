class User < ApplicationRecord
  enum plan: %i[starter premium]
  has_many :polls, foreign_key: :host_id

  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { minimum: 3, maximum: 50 },
                       uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 50 },
                       format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])([\x20-\x7E]){8,50}\Z/ }
  validates :email_notification, presence: true
  validates :plan, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable,
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :omniauthable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist,
                               omniauth_providers: %i[facebook google_oauth2]

  def jwt_payload
    {
      id: id,
      plan: plan,
      username: username,
      email: email
    }
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def self.from_omniauth(auth)
    client = where(email: auth.info.email).first

    return client if client&.confirmed?

    if client
      client.skip_confirmation!
      return client
    end

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      first_name, last_name = auth.info.name.split(' ')
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = first_name # assuming the user model has a name
      user.last_name = last_name # assuming the user model has a name
      user.username = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!
    end
  end
end
