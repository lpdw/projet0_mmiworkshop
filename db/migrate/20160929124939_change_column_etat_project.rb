class ChangeColumnEtatProject < ActiveRecord::Migration
  def change
  	remove_column :projects, :etat_project
  	add_column :projects, :etat_project, :integer
  end
end
