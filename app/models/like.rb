class Like < ActiveRecord::Base
	belongs_to :post

	validates :user_id, :presence => true, :uniqueness => {:scope => :post_id}

	before_save {
		logger.debug "post:#{self.post_id},user:#{user_id}"
	}
end