class DashboardController < ApplicationController
  authorize_resource

  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  def index
    @fields = Field.all

    @parent_fields = Field.all.where(parent_id: nil)

    if (params[:filter].eql?("inprogress"))
      @workshops=Workshop.where("'dateFin' >?",Time.now.to_date)
    elsif (params[:filter].eql?("end"))
      @workshops=Workshop.where("'dateFin' <=?",Time.now.to_date)
    else
      @workshops = Workshop.all
    end

    # Pour les professeurs, on affiche la liste des features demandées, pour les étudiants on affiche la liste des réponses, et des features en attente
    if current_user.profesor?
    @demandesValidation=FeaturesProject.joins(" inner join users_projects on features_projects.project_id=users_projects.project_id").where("features_projects.status=? and users_projects.user_id=?",1,current_user.id)
  else
    # pour les etudiants, on affiche les badges validés et/ou rejetés ( 5 derniers)
    @demandesValidation=FeaturesProject.joins(" inner join users_projects on features_projects.project_id=users_projects.project_id").where("users_projects.user_id=? and (features_projects.status=? OR features_projects.status=?) ",current_user.id,2,3).reorder(date_badge_valide: :desc).limit(5)

  end
#Les utilisateurs n'ont accès aux statistiques que des projets auxquels ils sont associés
    @projects = Project.joins("INNER JOIN users_projects ON projects.id=users_projects.project_id").where("users_projects.user_id= ?",current_user.id)
    @fieldsParents = Field.all.where(parent_id: nil)
    @featuresSearch= Feature.search(params[:search])
    @features= Feature.all
    @featuresProject=FeaturesProject.all


    @user = current_user
  end

  # GET /projects/1/stats
  def stats
    @project= Project.all
  end


end
