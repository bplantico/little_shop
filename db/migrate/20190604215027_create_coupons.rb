class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string  :code, unique: true
      t.boolean :active, default: true
      t.decimal :discount_amount

      t.timestamps

      t.references :merchant, foreign_key: {to_table: :users}
    end
  end
end
