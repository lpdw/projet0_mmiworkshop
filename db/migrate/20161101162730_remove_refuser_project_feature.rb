class RemoveRefuserProjectFeature < ActiveRecord::Migration
  def change
  	remove_column :features_projects, :refuser, :boolean
  end
end
