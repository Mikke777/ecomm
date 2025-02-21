class AddCheckoutSessionIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :checkout_session_id, :string
    add_index :orders, :checkout_session_id, unique: true
  end
end
