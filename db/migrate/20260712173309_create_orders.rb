class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :status, null: false, default: "created"

      t.timestamps
    end

    add_check_constraint :orders, "amount_cents > 0", name: "orders_amount_positive"
  end
end
