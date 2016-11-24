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
    has_and_belongs_to_many :users, join_table: :users_projects
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

    def has_valid_feature?(feature)
        features.where('status=?', 2).include? feature
    end

    def all_features
        (features + child_features).uniq
    end

    # Récupération des dates de début et de fin d'un projet (lié à un Workshop)
    def get_project_start_date(workshop_id)
        Workshop.where('id=?', workshop_id).pluck(:dateDebut)[0].to_date
    end

    def get_project_end_date(workshop_id)
        Workshop.where('id=?', workshop_id).pluck(:dateFin)[0].to_date
      end

    # Récupérer le nombre de features demandés par jour, du début du Workshop à la fin du Workshop
    def get_feature_asked_by_day(project, debutProjet, finProjet)
        # si la date de fin de projet est dépassée, le graph s'affiche du début du projet à la fin du projet, sinon de la date du début à la date du jour
        aujourdhui = Time.now.to_date
        finProjet = aujourdhui if (finProjet - aujourdhui).to_i > 0
        Project.joins('LEFT JOIN features_projects ON features_projects.project_id = projects.id').where('features_projects.project_id=?', project[:id]).group(:name).group_by_day(:date_demande, range: debutProjet..finProjet).count('case when date_demande IS NOT NULL THEN 0 end')
    end

    def get_features_asked(project)
        project.features.where('status=1').map(&:name)
      end

    def proj_feat(feature, project)
        FeaturesProject.where(['project_id=? and feature_id=?', project[:id], feature[:id]]).first
    end

    def in_users?(user)
        users.include? user
    end

    def note
        features_with_level(1) + features_with_level(2) * 2 + features_with_level(3) * 3
    end

    def features_with_level(level)
        result = 0
        Feature.all.each do |feature|
            result += 1 if has_feature?(feature) && (feature.level == level)
        end
        result
    end

    def to_s
        name.to_s
    end
end
