class CreateFeaturesProjects < ActiveRecord::Migration
  def change
    create_table :features_projects, id: false do |t|
      t.references :feature
      t.references :project
    end
    add_index :features_projects, [:feature_id, :project_id]
    add_index :features_projects, :feature_id
    add_index :features_projects, :project_id
  end
end
