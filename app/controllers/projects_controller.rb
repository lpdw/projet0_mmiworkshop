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
    @features = Feature.all
  end

  def synthesis
    @projects = Project.all
    @features = Feature.all
  end

  # GET /projects/1
  def show
    @fields = Field.all
    @projects = Project.all
    @fieldsParents = Field.all.where(parent_id: nil)
    @featuresSearch= Feature.search(params[:search])
    @features= Feature.all
    @workshops=Workshop.all

  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # GET /projects/1/stats
  def stats
    @project= Project.all
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

    # @project = Project.find(params[:id])
    # @feature = Feature.find(params[:data][:feature_id])
    # Find the link between project and feature
    @projectsfeature = FeaturesProject.where(["project_id=? and feature_id=?", params[:id], params[:data][:feature_id]]).first
    @user = current_user
    # render :text => @user.inspect
    # feature = Feature.new(:feature_id => params[:data][:feature_id], :project_id => params[:id])
    # FeaturesProject.new(params[:data])
    # @project.features << @feature
    if(@user.admin == true || @user.profesor == true)
      params[:data][:status] = 2
    else
      params[:data][:status] = 1
    end
    # Create if nil
    if @projectsfeature.nil?
      sql = "INSERT INTO features_projects VALUES (#{params[:data][:feature_id]},#{params[:data][:project_id]},#{params[:data][:status]},'#{params[:data][:commentaire]}',now())"
    # Update else
    else
      sql = "UPDATE features_projects SET status = #{params[:data][:status]}, commentaire = '#{params[:data][:commentaire]}' WHERE feature_id = #{params[:data][:feature_id]} AND project_id = #{params[:data][:project_id]}"
      # @projectsfeature[:status] = 2
      # @projectsfeature[:commentaire] = params[:data][:comment]
      # @projectsfeature.update(commentaire: "toto")
      # render :text => @projectsfeature.inspect
      # @projectsfeature.save
    end
    render :text => sql
    # Execute the query
    ActiveRecord::Base.connection.execute sql
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