class CreatePaypalEmails < ActiveRecord::Migration
  def change
    create_table :paypal_emails do |t|

    	t.string :email
      t.timestamps
    end
  end
end
