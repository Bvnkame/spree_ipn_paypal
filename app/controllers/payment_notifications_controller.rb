require 'base64'
module Spree
  class PaymentNotificationsController < ApplicationController
    protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller
    def create
      response = validate_IPN_notification(request.raw_post)
      case response
      when "VERIFIED"
        p Base64.decode64(params[:custom])
        p "==============fjdsakfjaksdfjasdkfjaksdfjaksdjfkasdjfk ==========="
        # check that paymentStatus=Completed
        # check that txnId has not been previously processed
        # check that receiverEmail is your Primary PayPal email
        # check that paymentAmount/paymentCurrency are correct
        # process payment
        # if params[:payment_status] == "Completed" && params[:txnId]
      when "INVALID"
        p "vao invalid"
        # log for investigation
      else
        p "vao error"
        # error
      end
        p "cham het"
      render :nothing => true
    end 
    protected 
    def validate_IPN_notification(raw)
      uri = URI.parse('https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate')
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 60
      http.read_timeout = 60
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      response = http.post(uri.request_uri, raw,
       'Content-Length' => "#{raw.size}",
       'User-Agent' => "My custom user agent"
       ).body

    end

    def check_exist_txnId(txnId)
      
    end
  end
end