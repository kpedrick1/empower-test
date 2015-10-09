class AddUserFields < ActiveRecord::Migration
  def change

    add_column :users, :username, :string

    add_column :users, :type, :string

    add_column :users, :approved, :boolean, :default => false, :null => false

    add_column :users, :account_id, :string
    add_column :users, :portal_credential_id, :string

    add_column :users, :portal_credential_token, :string

    add_index  :users, :approved
    add_index :users, :account_id
    add_index :users, :portal_credential_id
    add_index :users, :portal_credential_token

  end
end
