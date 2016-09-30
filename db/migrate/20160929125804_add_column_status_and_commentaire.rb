class AddColumnStatusAndCommentaire < ActiveRecord::Migration
  def change
  	add_column :features_projects, :status, :integer
  	add_column :features_projects, :commentaire, :string
  end
end
