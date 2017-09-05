class AddLocaleToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :locale, :string, default: 'en'
  end
end
