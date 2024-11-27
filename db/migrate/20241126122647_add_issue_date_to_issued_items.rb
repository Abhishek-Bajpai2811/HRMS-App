class AddIssueDateToIssuedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :issued_items, :issued_date, :date
  end
end
