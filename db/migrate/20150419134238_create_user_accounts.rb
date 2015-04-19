class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :spree_user_accounts do |t|

    	t.integer :user_id
    	t.integer :account
    	t.string :currency, :default => "VND"

      t.timestamps
    end
  end
end
