class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :lastName
      t.string :firstName
      t.string :email
      t.float :award
      t.float :lastOrder1
      t.float :lastOrder2
      t.float :lastOrder3

      t.timestamps
    end
  end
end
