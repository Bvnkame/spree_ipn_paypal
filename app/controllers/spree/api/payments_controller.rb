module Spree
	module Api
		class PaymentsController < BaseApiController
			def check_result_transaction
				p params[:trans]

				@paypaltransaction = Prepaid::PaypalTransaction.where(:custom => params[:trans], :user_id => current_api_user.id).first
				if @paypaltransaction
					render "spree/api/payments/show", status: 200
				else
					@status = [ { "messages" => "Not Receive Reponse."}]
					render "spree/api/logger/log", status: 404
				end
			end
		end
	end
end