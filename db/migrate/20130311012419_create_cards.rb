class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cost
      t.string :power
      t.string :toughness
      t.text :super_types, array: true
      t.text :sub_types, array: true
      t.text :card_types, array: true
      t.string :colors, array: true
      t.string :color_indicator, array: true
      t.text   :card_text

      t.references :expansion

      t.timestamps
    end
  end
end
