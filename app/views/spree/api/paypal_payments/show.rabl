object @paypaltransaction

attributes :id, :receiver_email, :protection_eligibility, :payment_status

node(:pending_reason) { |p| p.pending_reason if p.payment_status != "Completed" }

child :prepaid_category => :prepaid_category do
	extends "spree/api/prepaid_categories/show"
end
