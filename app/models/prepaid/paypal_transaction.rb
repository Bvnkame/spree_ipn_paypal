module Prepaid
	class PaypalTransaction < ActiveRecord::Base
		belongs_to :prepaid_category, foreign_key: :prepaid_category_id, class_name: 'Prepaid::PrepaidCategory'
	end
end
