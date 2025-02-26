class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  # validates :email, presence: true, uniqueness: true
  # validates :password, presence: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :password, length: { maximum: 20 }
  validate :valid_date?

  enum :role, { user: "user", admin: "admin" }
  validates :role, inclusion: { in: roles.keys }

  def full_name
    [ first_name, last_name ].join(" ")
  end

  def super_admin?
    admin? && email == ENV["ADMIN_EMAIL"]
  end

  private

  def valid_date?
    if date_of_birth.present? && date_of_birth > Time.now.ago(15.years)
      errors.add(:date_of_birth, "must be at least 15 years old")
    end
  end
end
