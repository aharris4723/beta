class User < ApplicationRecord
	has_secure_password
	has_many :blogs
	has_many :gatherings
	has_many :comments
end
