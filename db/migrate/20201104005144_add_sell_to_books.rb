class AddSellToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :sell, :boolean, default: false, null: false
  end
end
