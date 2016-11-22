# == Schema Information
#
# Table name: workshops
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  dateDebut  :datetime         not null
#  dateFin  :datetime         not null


class Workshop < ActiveRecord::Base
  has_many :projects
  validates :name, presence: true
  validates :dateDebut, presence: true
  validates :dateFin, presence: true


  def to_s
  	"#{name}"
  end

  #Récupération des dates de début et de fin d'un projet (lié à un Workshop)
  def get_project_start_date(workshop_id)
    Workshop.where("id=?",workshop_id).pluck(:dateDebut)[0].to_date
  end

  def get_project_end_date(workshop_id)
    Workshop.where("id=?",workshop_id).pluck(:dateFin)[0].to_date

  end
end
