module Prepaid
	class UserAccount < ActiveRecord::Base
		self.table_name = "spree_user_accounts"
	end
end
