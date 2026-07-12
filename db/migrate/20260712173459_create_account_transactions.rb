class CreateAccountTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :account_transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :transaction_type, null: false
      t.integer :amount_cents, null: false

      t.timestamps
    end

    add_index :account_transactions,
              [ :order_id, :transaction_type ],
              unique: true,
              name: "unique_order_transaction_type"

    add_check_constraint :account_transactions,
                         "amount_cents <> 0",
                         name: "transaction_amount_not_zero"
  end
end
