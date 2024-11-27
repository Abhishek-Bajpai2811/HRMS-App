class AddReturnDateToIssuedItems < ActiveRecord::Migration[7.2]
  def change
    add_column :issued_items, :return_date, :date
  end
end
