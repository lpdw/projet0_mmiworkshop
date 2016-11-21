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
require 'cgi'
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
    #@usersProject=UsersProject.all
    @badgesAttente=FeaturesProject.joins("INNER JOIN projects ON features_projects.project_id=projects.id").where("status=1")

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
    if !params[:data].nil?
      @projectsfeature = FeaturesProject.where(["project_id=? and feature_id=?", params[:id], params[:data][:feature_id]]).first
      @user = current_user
      if(@user.admin == true || @user.profesor == true)
        params[:data][:status] = (params[:data][:status] == '') ? 2:  params[:data][status];
        if !@projectsfeature.nil?
          # Protect field to not change if prof or admin
          params[:data][:commentaire] = @projectsfeature[:commentaire]
        end
      else
        params[:data][:status] = 1
        if !@projectsfeature.nil?
          # Protect field to not change if not prof or admin
          params[:data][:commentaire_prof] = @projectsfeature[:commentaire_prof]
        end
      end
      # Bug fixe caractere speciaux
      params[:data][:commentaire_prof] = CGI.escapeHTML(params[:data][:commentaire_prof]);
      params[:data][:commentaire] = CGI.escapeHTML(params[:data][:commentaire]);
      # Create if nil
      if @projectsfeature.nil?
        insert = (params[:data][:status] == 1) ? "'#{@user.id}'" : "'#{@user.id}','#{@user.id}',now()";
        sql = "INSERT INTO features_projects VALUES (#{params[:data][:feature_id]},#{params[:data][:project_id]},#{params[:data][:status]},'#{params[:data][:commentaire]}',now(),'#{params[:data][:commentaire_prof]}',#{insert})"
      # Update else
      else
        update = "status = #{params[:data][:status]}, commentaire = '#{params[:data][:commentaire]}', commentaire_prof = '#{params[:data][:commentaire_prof]}'"
        sql = "UPDATE features_projects SET #{update} WHERE feature_id = #{params[:data][:feature_id]} AND project_id = #{params[:data][:project_id]}"
      end
      render :text => sql
      # Execute the query
      ActiveRecord::Base.connection.execute sql
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

  def autocomplete_feature
    if params[:term]
      @autocomplete_values = ""
      if params[:type] == "users_projects"
        @autocomplete_values = User.where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?', "%#{params[:term].downcase}%", "%#{params[:term].downcase}%", "%#{params[:term].downcase}%")
      elsif params[:type] == "features_projects"
        @autocomplete_values = Feature.where('name ILIKE ?', "%#{params[:term].downcase}%")
      end
      respond_to do |format|  
        format.html
        format.json { render :json => @autocomplete_values.as_json(:only => [:id], :methods => [:name_for_associated_inuts]) }
      end
    end
  end

  def get_add_from_list_modal
    if params[:id].nil?
      @project = Project.new
    else
      @project = Project.find(params[:id])
    end
    unless params[:label].nil? || params[:input_class].nil?
      @label = params[:label]
      @input_class = params[:input_class]
      render :partial => "associated_inputs_modal"
    end
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :url, :github, :notes, :workshop_id, feature_ids: [], user_ids: [])
  end
end
