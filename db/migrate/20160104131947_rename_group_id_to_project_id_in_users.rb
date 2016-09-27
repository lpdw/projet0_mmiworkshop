class RenameGroupIdToProjectIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :group_id, :project_id
  end
end
