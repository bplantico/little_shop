class ChangeAddressNickname < ActiveRecord::Migration[5.1]
  def change
    change_column :addresses, :nickname, :string, :unique => false
  end
end
