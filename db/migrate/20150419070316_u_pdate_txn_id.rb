class UPdateTxnId < ActiveRecord::Migration
  def change
  	rename_column :paypal_transactions, :txnId, :txn_id
  end
end
