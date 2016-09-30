class RemoveColumnGroupUser < ActiveRecord::Migration
  def change
  	remove_column :users_projects, :group_user
  end
end
