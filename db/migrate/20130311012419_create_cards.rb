class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cost
      t.string :power
      t.string :toughness
      t.text :super_types, array: true
      t.text :sub_type, array: true
      t.text :card_types, array: true
      t.string :colors, array: true
      t.string :color_indentifier, array: true
      t.text   :card_text
      t.text   :reminder_text
      t.text   :flavor_text
      t.string :illustrator
      t.string :rarity
      t.string :card_number
      t.integer :multiverse_number

      t.references :expansion

      t.timestamps
    end
  end
end
