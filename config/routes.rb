Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post '/paypal', :to => "payment_notifications#create"
end
