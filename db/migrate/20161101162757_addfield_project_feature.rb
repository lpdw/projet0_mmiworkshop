class AddfieldProjectFeature < ActiveRecord::Migration
  def change
  	add_column :features_projects, :id_demandeur, :int
  	add_column :features_projects, :id_prof_valide, :int
  	add_column :features_projects, :date_badge_valide, :datetime
  	change_column :features_projects, :status, :int, :default => 2
  end
end
