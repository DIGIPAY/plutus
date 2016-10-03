class CreatePlutusBalanceLogs < ActiveRecord::Migration
  def change
    create_table :plutus_balance_logs do |t|
      t.references :account, index: true, foreign_key: true
      t.decimal :balance, precision: 20, scale: 10
      t.integer :month_index
    end
    add_index :plutus_balance_logs, :month_index
  end
end
