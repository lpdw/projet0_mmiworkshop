class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :color
      t.integer :position

      t.timestamps null: false
    end
  end
end
