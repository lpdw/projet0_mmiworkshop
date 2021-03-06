class Dashboard < ActiveRecord::Base

  has_and_belongs_to_many :users, :join_table => :users_projects
  # has_and_belongs_to_many :features, uniq: true
  has_many :features_projects
  has_many :features, through: :features_projects
  belongs_to :workshop

  default_scope { order('name') }

  validates :name, presence: true

  def has_feature?(feature)
    features.include? feature
  end

  def all_features
    (features + child_features).uniq
  end

  def proj_feat(feature, project)
    FeaturesProject.where(["project_id=? and feature_id=?", project[:id], feature[:id]]).first
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
