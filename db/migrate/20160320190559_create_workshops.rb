class CreateWorkshops < ActiveRecord::Migration
  def change
    create_table :workshops do |t|
      t.string :name, null: false
      t.text :description
      t.string :url

      t.timestamps null: false
    end
  end
end
