class RenameProjectAsDescriptionInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :project, :description
  end
end
