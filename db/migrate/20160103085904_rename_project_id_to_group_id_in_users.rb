class RenameProjectIdToGroupIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :project_id, :group_id
  end
end
