class CreatePrepaidCategories < ActiveRecord::Migration
  def change
    create_table :prepaid_categories do |t|

    	t.string :type_name
    	t.integer :price
    	t.string :currency
    	t.integer :bonus_price
    	t.string :bonus_currency
    	t.string :shipping_type

      t.timestamps
    end
  end
end
