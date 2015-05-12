module Spree
	module Api
		class PaypalPaymentsController < BaseApiController
			def check_result_transaction

				@paypaltransaction = Prepaid::PaypalTransaction.where(:custom => params[:trans], :user_id => current_api_user.id).first
				if @paypaltransaction
					render "spree/api/paypal_payments/show", status: 200
				else
					@status = [ { "messages" => "Not Receive Reponse."}]
					render "spree/api/logger/log", status: 404
				end
			end
		end
	end
end