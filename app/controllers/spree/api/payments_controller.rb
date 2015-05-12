Spree::Api::PaymentsController.class_eval do

	def update_status
		@order = Spree::Order.find_by(number: params[:order_number])
		authorize! :update, @order

		@payment = Spree::Payment.find_by(order_id: @order.id)

		if payment_params[:status].downcase == "complete"
			@payment.update(is_pay: TRUE)
		else
			@payment.update(is_pay: FALSE)
		end

		@status = [{ "messages" => "Update Status Successful"}]
		render "spree/api/logger/log", status: 201
	end

	private
	def payment_params
		params.permit( :payment => [
			:status
			])
	end

end