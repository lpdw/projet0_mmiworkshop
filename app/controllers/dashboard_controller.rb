class DashboardController < ApplicationController
  authorize_resource

  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  def index
    @workshops = Workshop.all
    @fields = Field.all

    @parent_fields = Field.all.where(parent_id: nil)

    @projects = Project.all
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
