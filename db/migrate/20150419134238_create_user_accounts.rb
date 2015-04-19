class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :spree_user_accounts do |t|

    	t.integer :user_id
    	t.integer :account
    	t.string :currency, :default => "USD"

      t.timestamps
    end
  end
end
