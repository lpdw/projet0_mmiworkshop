class AddColumnsDatesWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :dateDebut, :datetime
    add_column :workshops, :dateFin, :datetime
  end
end
