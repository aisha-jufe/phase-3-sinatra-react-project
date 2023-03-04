require 'bcrypt'

class User < ActiveRecord::Base
  has_many :projects
  has_many :skills

    # table consists of password_hash as a column to store password hashes in DB
  includes 'bcrypt'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password
  
end