class AddQuantityToIssuedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :issued_items, :quantity, :integer
  end
end
