require 'base64'
module Spree
  class PaymentNotificationsController < ApplicationController
    protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller
    def create
      response = validate_IPN_notification(request.raw_post)
      case response
      when "VERIFIED"
        # check that paymentStatus=Completed
        # if params[:payment_status] == "Completed"

          # check that txnId has not been previously processed
          unless Prepaid::PaypalTransaction.exists?(:txn_id => params[:txn_id])
            if Prepaid::PaypalEmail.exists?(:email => params[:receiver_email])
              
              custom = Base64.decode64(params[:custom]).split(',')

              if check_account_correct(params[:mc_gross], custom[1], custom[3])
              else
                p "account not correct"
              end
            else
              p "email not of business"
            end
          else 
            p "transaction exist"
          end
        # else 
        #   p "payment status not completed"
        # end
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

    def check_account_correct(mc_gross, rate, prepaid_category_id)
      # money = Prepaid::PrepaidCategory.find(prepaid_category_id).price
      money = Prepaid::PrepaidCategory.find(1).price
      
      trans_money = mc_gross.to_f * rate.to_f
      p "money"
      p money
      p "trans djfkasd money"
      p trans_money


    end
  end
end