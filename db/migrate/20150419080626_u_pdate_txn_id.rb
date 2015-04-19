class UPdateTxnId < ActiveRecord::Migration
  def change
  		rename_column :paypal_transactions, :perpaid_category_id, :prepaid_category_id
  end
end
