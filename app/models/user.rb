class User < ActiveRecord::Base

	has_many :likes

	def self.create_with_omniauth(auth)
		create! do |user|
			user.provider = auth["provider"]
			user.uid = auth["uid"]
			user.name = auth["info"]["name"]
			user.nickname = auth["info"]["nickname"].downcase
		end
	end


  def admin?
	ENV['ADMINS'].split(',').include?(self.nickname)
  end
end