class AddColumnGroupUser < ActiveRecord::Migration
  def change
  	add_column :users_projects, :group_user, :string 
  end
end
