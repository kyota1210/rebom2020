class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string      :zip_code,        null: false
      t.integer     :prefecture_id,   null: false
      t.string      :city,            null: false
      t.string      :street,          null: false
      t.string      :building
      t.string      :phone_number,    null: false
      t.references  :order,           null: false, foreign_key: true
      t.timestamps
    end
  end
end