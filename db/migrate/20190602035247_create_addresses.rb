class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|

      t.string  :nickname, unique: true
      t.boolean :active, default: false
      t.string  :street_address
      t.string  :city
      t.string  :state
      t.string  :zip

      t.timestamps

      t.references :user, foreign_key: true
    end
  end
end
