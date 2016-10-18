# == Schema Information
#
# Table name: features_projects
#
#  projects-id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#
class FeaturesProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :feature
end