class AddWorkshopToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :workshop_id, :integer, index: true
  end
end
