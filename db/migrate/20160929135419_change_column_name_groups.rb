class ChangeColumnNameGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :na
  	add_column :groups, :name, :string
  end
end
