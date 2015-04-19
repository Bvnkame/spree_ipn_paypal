Spree::User.class_eval do 

	has_many :user_accounts, :class_name => "Prepaid::UserAccount", foreign_key: 'user_id'

end
