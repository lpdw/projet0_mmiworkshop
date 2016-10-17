class AddFieldsToField < ActiveRecord::Migration
  def change
    add_column :fields, :icon, :string
    add_column :fields, :parent_id, :integer
  end
end
