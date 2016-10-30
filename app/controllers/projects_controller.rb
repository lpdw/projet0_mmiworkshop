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

# L'utilisateur n'a accès qu'aux projets auxquels il est assigné (si il est élève)
    if(!current_user.admin? && !current_user.profesor?)
      @projects = Project.joins("INNER JOIN users_projects ON projects.id=users_projects.project_id").where("users_projects.user_id= ?",current_user.id)
    else
      @projects=Project.all
    end
    @features = Feature.all

    @badgesAttente=Project.joins("INNER JOIN features_projects ON project.id=features_projects.project_id").where("status=1")
  end

  def synthesis
    @projects = Project.all
    @features = Feature.all
  end

  # GET /projects/1
  def show
    @fields = Field.all

    @parent_fields = Field.all.where(parent_id: nil)


    @projects = Project.joins("INNER JOIN users_projects ON projects.id=users_projects.project_id").where("users_projects.user_id= ?",current_user.id)
    @fieldsParents = Field.all.where(parent_id: nil)
    @featuresSearch= Feature.search(params[:search])
    @features= Feature.all
    @workshops=Workshop.all

    @featuresProject=FeaturesProject.all
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
    @project = Project.all
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
    # if(!self.in_users?(current_user) || !current_user.admin)
    #   return false
    # end
    if !params[:data].nil?
      @projectsfeature = FeaturesProject.where(["project_id=? and feature_id=?", params[:id], params[:data][:feature_id]]).first
      @user = current_user
      # render :text => @user.inspect
      # feature = Feature.new(:feature_id => params[:data][:feature_id], :project_id => params[:id])
      # FeaturesProject.new(params[:data])
      # @project.features << @feature
      if(@user.admin == true || @user.profesor == true)
        params[:data][:status] = 2
        if !@projectsfeature.nil?
          # Protect field to not change if prof or admin
          params[:data][:commentaire] = @projectsfeature[:commentaire]
          if params[:data][:reject] == 'true'
            params[:data][:status] = 1
          end
        end
      else
        params[:data][:status] = 1
        if !@projectsfeature.nil?
          # Protect field to not change if not prof or admin
          params[:data][:commentaire_prof] = @projectsfeature[:commentaire_prof]
        end
      end
      # Create if nil
      if @projectsfeature.nil?
        sql = "INSERT INTO features_projects VALUES (#{params[:data][:feature_id]},#{params[:data][:project_id]},#{params[:data][:status]},'#{params[:data][:commentaire]}',now(),'f','#{params[:data][:commentaire_prof]}')"
      # Update else
      else
        update = "status = #{params[:data][:status]}, commentaire = '#{params[:data][:commentaire]}', commentaire_prof = '#{params[:data][:commentaire_prof]}', refuser = '#{params[:data][:reject]}'"
        sql = "UPDATE features_projects SET #{update} WHERE feature_id = #{params[:data][:feature_id]} AND project_id = #{params[:data][:project_id]}"
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
    elsif @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end

  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  def get_features_modal
    if params[:id].nil?
      @project = Project.new
    else
      @project = Project.find(params[:id])
    end
    render :partial => "features_modal"
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :url, :github, :notes, :workshop_id, feature_ids: [])
  end
end
