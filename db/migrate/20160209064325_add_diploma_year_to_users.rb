class AddDiplomaYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :diploma_year, :integer
  end
end
