class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.integer :status_id,       null: false
      t.integer :transfer_fee_id, null: false
      t.integer :price,           null: false
      t.references :book,         null: false, foreign_key: true
      t.timestamps
    end
  end
end
