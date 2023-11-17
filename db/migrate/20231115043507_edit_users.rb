class EditUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password_digest
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
