class RenameGroupsToProjects < ActiveRecord::Migration
  def change
    rename_table :groups, :projects
  end
end
