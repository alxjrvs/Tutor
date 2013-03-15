class CreateExpansions < ActiveRecord::Migration
  def change
    create_table :expansions do |t|
      t.string :name
      t.string :short_name
      t.string :tagline
      t.boolean :mythicable
      t.date :release_date


      t.references :block

      t.timestamps
    end
  end
end
