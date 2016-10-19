class CreateUsersProjects < ActiveRecord::Migration
  def change
    create_table :users_projects, id: false do |t|
    	t.references :user
    	t.references :project
    end
    add_index :users_projects, [:user_id, :project_id]
    add_index :users_projects, :user_id
    add_index :users_projects, :project_id
  end
end
