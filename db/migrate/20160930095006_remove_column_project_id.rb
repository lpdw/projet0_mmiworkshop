class RemoveColumnProjectId < ActiveRecord::Migration
  def change
  	remove_column :users, :project_id
  end
end
