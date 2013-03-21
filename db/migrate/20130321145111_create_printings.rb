class CreatePrintings < ActiveRecord::Migration
  def change
    create_table :printings do |t|
      t.text   :raw_text
      t.text   :rules_text
      t.string :name
      t.text   :flavor_text
      t.text   :watermark
      t.string :illustrator
      t.string :rarity
      t.string :card_number
      t.integer :multiverse_number

      t.references :card
      t.references :expansion

      t.timestamps
    end
  end
end
