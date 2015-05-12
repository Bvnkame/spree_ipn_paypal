Spree::User.class_eval do 

	has_one :user_account, :class_name => "Prepaid::UserAccount", foreign_key: 'user_id'

end
