require 'base64'
module Spree
  class PaymentNotificationsController < ApplicationController
    protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller
    def create
      response = validate_IPN_notification(request.raw_post)
      case response
      when "VERIFIED"
        # Get Infor custom from front-end
        custom = Base64.decode64(params[:custom]).split(',')

        # Save Database Paypal Transaction
        if Prepaid::PaypalTransaction.exists?(:txn_id => params[:txn_id])
          trans = Prepaid::PaypalTransaction.find_by(txn_id: params[:txn_id])
          trans.update(receiver_email: params[:receiver_email],
                        user_id: @user.id, payer_email: params[:payer_email],
                        mc_gross: params[:mc_gross], mc_fee: params[:mc_fee],
                        mc_currency: params[:mc_currency], prepaid_category_id: custom[3],
                        payment_status: params[:payment_status], pending_reason: params[:pending_reason],
                        protection_eligibility: params[:protection_eligibility], payment_date: params[:payment_date],
                        custom: custom[2])
        else
          Prepaid::PaypalTransaction.create(txn_id: params[:txn_id]),
              receiver_email: params[:receiver_email],
              user_id: @user.id, payer_email: params[:payer_email],
              mc_gross: params[:mc_gross], mc_fee: params[:mc_fee],
              mc_currency: params[:mc_currency], prepaid_category_id: custom[3],
              payment_status: params[:payment_status], pending_reason: params[:pending_reason],
              protection_eligibility: params[:protection_eligibility], payment_date: params[:payment_date],
              custom: custom[2])
        end


        # check that paymentStatus=Completed
        if params[:payment_status] == "Completed"
          # check that txnId has not been previously processed
          unless Prepaid::PaypalTransaction.exists?(:txn_id => params[:txn_id])
            # check that receiverEmail is your Primary PayPal email
            if Prepaid::PaypalEmail.exists?(:email => params[:receiver_email])
              # check that paymentAmount/paymentCurrency are correct
              if check_account_correct(params[:mc_gross], custom[1], custom[3])
                # current_account = @user.Prepaid::UserAccount.find_by(user_id)
              else
                p "account not correct"
              end
            else
              p "email not of business"
            end
          end
        else 
          p "payment status not completed"
        end
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
      up_scope = money + 1000
      down_scope = money - 1000

      trans_money = mc_gross.to_f * rate.to_f
      if trans_money > down_scope && trans_money < up_scope
        return true
      else
        return false
      end
    end
  end
end