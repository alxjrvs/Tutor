class CreateBlock < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.timestamps
    end
  end
end
