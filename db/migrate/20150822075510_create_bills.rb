class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :item
      t.references :user
      t.references :group
      t.decimal :amount, precision: 8, scale: 2 
      t.timestamps null: false
    end
  end
end
