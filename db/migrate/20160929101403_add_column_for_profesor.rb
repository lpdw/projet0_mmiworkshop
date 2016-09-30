class AddColumnForProfesor < ActiveRecord::Migration
  def change
  	add_column :users, :profesor, :boolean, :default => false
  end
end
