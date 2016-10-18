class Features_project < ActiveRecord::Base
  belongs_to :project
  belongs_to :feature
end