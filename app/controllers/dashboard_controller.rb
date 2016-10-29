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
#Les utilisateurs n'ont accès aux statistiques que des projets auxquels ils sont associés
    @projects = Project.joins("INNER JOIN users_projects ON projects.id=users_projects.project_id").where("users_projects.user_id= ?",current_user.id)
    @fieldsParents = Field.all.where(parent_id: nil)
    @featuresSearch= Feature.search(params[:search])
    @features= Feature.all

    @user = current_user
  end

  # GET /projects/1/stats
  def stats
    @project= Project.all
  end


end
