class AddRejectToFeature < ActiveRecord::Migration
  def change
  	add_column :features_projects, :refuser, :boolean, default: false
  	add_column :features_projects, :commentaire_prof, :text
  end
end
