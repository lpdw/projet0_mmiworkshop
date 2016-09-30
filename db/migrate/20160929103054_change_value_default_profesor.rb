class ChangeValueDefaultProfesor < ActiveRecord::Migration
  def change
  	change_column :users, :profesor,:boolean, :default => false 
  end
end
