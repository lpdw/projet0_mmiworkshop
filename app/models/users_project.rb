# == Schema Information
#
# Table name: users_projects
#
#  projects-id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#
class UsersProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end
