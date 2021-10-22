class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :username
      t.boolean :verified, default: false
      t.timestamps
    end
    add_index :users, :phone_number, unique: true
  end
end
