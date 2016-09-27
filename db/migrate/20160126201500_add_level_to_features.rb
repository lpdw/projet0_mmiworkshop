class AddLevelToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :level, :integer
  end
end
