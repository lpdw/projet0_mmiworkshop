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

class ProjectsController < ApplicationController
  authorize_resource

  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /projects
  def index
    @projects = Project.all
  end

  def synthesis
    @projects = Project.all
    @features = Feature.all
  end

  # GET /projects/1
  def show
    @fields = Field.all
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update

    # feature = Feature.new(:feature_id => params[:feature_id], :project_id => params[:id])
    @project = Project.find(params[:id])
    @feature = Feature.find(params[:feature_id])

    # debugger

    # @feature.update params[:feature][:comment]

    # @project.feature_ids.insert(-1,params[:feature_id])
    # toto = 5
    # @project.feature_ids = []
    # @project.feature_ids.push(5,7,4,744)
    # @project.feature_ids << 12
    # @project.feature_ids[2] << toto
    # render :text => params[:feature_id]
    @project.features << @feature
    # render :text => @project.features.inspect
    # @feature
    # render :text => @feature.inspect
    # puts @project.inspect
    # render :text => feature
    # @project.update(@project)
    # if @project.update(project_params)
    #   redirect_to @project, notice: 'Project was successfully updated.'
    # else
    #   render :edit
    # end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :url, :github, :notes, :workshop_id, feature_ids: [])
  end
end