class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :email, null: false
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
