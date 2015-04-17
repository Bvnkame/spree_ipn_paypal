Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post '/paypal', :to => "payment_notifications#create"
    namespace :api do
  		resources :prepaid_categories
  	end
end
