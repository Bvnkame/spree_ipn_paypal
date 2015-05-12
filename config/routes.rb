Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :api do
		resources :prepaid_categories
	end

  post '/paypal', :to => "payment_notifications#create"
  get "/api/transactions/:trans" => "api/paypal_payments#check_result_transaction"
  put "/api/payments/status/:order_number" => "api/payments#update_status"		
end
