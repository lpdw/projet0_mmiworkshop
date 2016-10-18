# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  icon        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#  field_id    :integer
#  level       :integer
#

class Feature < ActiveRecord::Base
  # has_and_belongs_to_many :projects, uniq: true
  has_many :features_projects
  has_many :projects, through: :features_projects
  has_many :users, through: :projects
  belongs_to :field
  default_scope { order('position, level') }

  def color
    field.smart_color unless field.nil?
  end

  def icon
    field.icon
  end

  def name_with_hierarchy
    "#{field.ancestors} #{name} (#{description})"
  end

  def to_s
    "#{name}"
  end
end
