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
  has_and_belongs_to_many :users, :join_table => :users_projects
  # has_and_belongs_to_many :features, uniq: true
  has_many :features_projects
  has_many :features, through: :features_projects
  belongs_to :workshop

  default_scope { order('name') }

  validates :name, presence: true
  validates :workshop_id, presence: true

  def has_feature?(feature)
  	features.include? feature
  end

  def all_features
    (features + child_features).uniq
  end

#Récupération des dates de début et de fin d'un projet (lié à un Workshop)
def get_project_start_date(workshop_id)
  Workshop.where("id=?",workshop_id).pluck(:dateDebut)[0].to_date
end

def get_project_end_date(workshop_id)
  Workshop.where("id=?",workshop_id).pluck(:dateFin)[0].to_date

end
def get_feature_asked_by_day(project,debutProjet,finProjet)
Project.joins("LEFT JOIN features_projects ON features_projects.project_id = projects.id").where("features_projects.project_id=?",project[:id]).group(:name).group_by_day(:date_demande, range:debutProjet..finProjet).count("case when date_demande IS NOT NULL THEN 0 end")
end

def get_features_asked(project)
  project.features.where("status=1").map {|c|c.name}

end

  def proj_feat(feature, project)
    FeaturesProject.where(["project_id=? and feature_id=?", project[:id], feature[:id]]).first
  end

  def in_users?(user)
    self.users.include? user
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
