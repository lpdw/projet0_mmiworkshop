# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url         :string
#  github      :string
#  workshop_id :integer
#  notes       :text
#

class Project < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :features, uniq: true
  belongs_to :workshop

  default_scope { order('name') }

  validates :name, presence: true

  def has_feature?(feature)
  	features.include? feature
  end

  def note
    features_with_level(1) + features_with_level(2)*2 + features_with_level(3)*3
  end

  def features_with_level(level)
    result = 0
    Feature.all.each do |feature|
      result += 1 if has_feature? feature and feature.level == level
    end
    result 
  end

  def to_s
    "#{name}"
  end
end
