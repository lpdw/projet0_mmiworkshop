class AddColumnEtatProject < ActiveRecord::Migration
  def change
  	add_column :projects, :etat_project, :string 
  end
end
