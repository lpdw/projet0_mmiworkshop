class AddFields < ActiveRecord::Migration
  def change
    add_column :features, :position, :integer
    add_column :features, :field_id, :integer
  end
end
