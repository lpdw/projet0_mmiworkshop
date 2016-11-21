class AddUsersProjectsToGroups < ActiveRecord::Migration
  def change
    add_reference :users_projects, :group, index: true
    add_foreign_key :users_projects, :groups
  end
end
