class User < ActiveRecord::Base
  has_many :recipes

  validates_presence_of  :username, :password
  validates_uniqueness_of :username, presence: {message: "That username is already taken, please use another username."}
end
