class User < ApplicationRecord
	has_many :blogs
	has_many :gatherings
	has_many :comments
end
