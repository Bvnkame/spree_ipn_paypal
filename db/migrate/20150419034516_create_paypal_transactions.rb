class CreatePaypalTransactions < ActiveRecord::Migration
  def change
    create_table :paypal_transactions do |t|

    	t.string :txnId
    	t.string :receiver_email
    	t.integer :user_id
    	t.string :payer_email
    	t.integer :mc_gross
    	t.integer :mc_fee
    	t.string :mc_currency
    	t.integer :perpaid_category_id
    	t.datetime :payment_date
    	t.string :payment_type
    	t.string :payment_status
    	t.string :pending_reason
    	t.string :protection_eligibility
    	t.string :custom

      t.timestamps
    end
  end
end
