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
        @user = Spree::User.find_by(email: custom[0])

        # check that paymentStatus=Completed
        if params[:payment_status] == "Completed"
          # check that txnId has not been previously processed
          unless Prepaid::PaypalTransaction.exists?(:txn_id => params[:txn_id], :payment_status => "Completed")
            # check that receiverEmail is your Primary PayPal email
            if Prepaid::PaypalEmail.exists?(:email => params[:receiver_email])
              # check that paymentAmount/paymentCurrency are correct
              @prepaid_category = Prepaid::PrepaidCategory.find(1)

              if check_account_correct(params[:mc_gross], custom[1], @prepaid_category.price)
                @user_account = @user.user_account
                if @user_account
                  current_account = @user_account.account
                  update_account = current_account + money + @prepaid_category.bonus_price
                  @user_account.update(account: update_account)
                else
                  Prepaid::UserAccount.create(:user_id => @user.id, :account => money)
                end
              else
                p "account not correct"
              end
            else
              p "email not of business"
            end
          end
        else 
          p "payment status not completed" s
        end

        # Save Database Paypal Transaction
        if Prepaid::PaypalTransaction.exists?(:txn_id => params[:txn_id])
          trans = Prepaid::PaypalTransaction.find_by(txn_id: params[:txn_id])
          trans.update(receiver_email: params[:receiver_email],
                        user_id: @user.id, payer_email: params[:payer_email],
                        mc_gross: params[:mc_gross], mc_fee: params[:mc_fee],
                        mc_currency: params[:mc_currency], prepaid_category_id: custom[3],
                        payment_status: params[:payment_status], pending_reason: params[:pending_reason],
                        protection_eligibility: params[:protection_eligibility], payment_date: params[:payment_date],
                        payment_type: params[:payment_type], custom: custom[2])
        else
          Prepaid::PaypalTransaction.create(txn_id: params[:txn_id],
              receiver_email: params[:receiver_email],
              user_id: @user.id, payer_email: params[:payer_email],
              mc_gross: params[:mc_gross], mc_fee: params[:mc_fee],
              mc_currency: params[:mc_currency], prepaid_category_id: custom[3],
              payment_status: params[:payment_status], pending_reason: params[:pending_reason],
              protection_eligibility: params[:protection_eligibility], payment_date: params[:payment_date],
              payment_type: params[:payment_type], custom: custom[2])
        end





      when "INVALID"
        # log for investigation
      else
        # error
      end
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

    def check_account_correct(mc_gross, rate, money)
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