class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string     :highlight, null: false
      t.string     :text,      null: false
      t.references :book,      null: false, foreign_key: true
      t.timestamps
    end
  end
end
