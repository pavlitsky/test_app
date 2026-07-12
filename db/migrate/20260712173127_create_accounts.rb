class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :balance_cents, null: false, default: 0

      t.timestamps
    end

    add_check_constraint :accounts, "balance_cents >= 0", name: "accounts_balance_non_negative"
  end
end
