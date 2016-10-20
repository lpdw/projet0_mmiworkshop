class AddDateValidateToFeature < ActiveRecord::Migration
  def change
  	add_column :features_projects, :date_demande, :datetime
  end
end
