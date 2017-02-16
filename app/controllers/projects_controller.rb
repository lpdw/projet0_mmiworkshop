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
    
    skip_authorize_resource only: [:search_features, :update]

    # GET /projects
    def index
        # L'utilisateur n'a accès qu'aux projets auxquels il est assigné (si il est élève)
        if !current_user.admin? && !current_user.profesor?
            @projects = Project.joins('INNER JOIN users_projects ON projects.id=users_projects.project_id').where('users_projects.user_id= ?', current_user.id)
        else
            @projects = Project.all
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

        @projects = Project.joins('INNER JOIN users_projects ON projects.id=users_projects.project_id').where('users_projects.user_id= ?', current_user.id)
        @fieldsParents = Field.all.where(parent_id: nil)
        @featuresSearch = Feature.search(params[:search])
        @features = Feature.all
        @workshops = Workshop.all

        @featuresProject = FeaturesProject.all
        @badgesAttente = FeaturesProject.joins('INNER JOIN projects ON features_projects.project_id=projects.id').where('status=1')
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
            @projectsfeature = FeaturesProject.where(['project_id=? and feature_id=?', params[:id], params[:data][:feature_id]]).first
            @user = current_user
            if @user.admin == true || @user.profesor == true
                params[:data][:status] = params[:data][:status] == '' ? 2 : params[:data][:status]
                unless @projectsfeature.nil?
                    # Protect field to not change if prof or admin
                    params[:data][:commentaire] = @projectsfeature[:commentaire]
                end
            else
                params[:data][:status] = 1
                unless @projectsfeature.nil?
                    # Protect field to not change if not prof or admin
                    params[:data][:commentaire_prof] = @projectsfeature[:commentaire_prof]
                end
            end
            # Bug fixe caractere speciaux
            unless params[:data][:commentaire_prof].nil?
                params[:data][:commentaire_prof] = CGI.escapeHTML(params[:data][:commentaire_prof])
            end
            unless params[:data][:commentaire].nil?
                params[:data][:commentaire] = CGI.escapeHTML(params[:data][:commentaire])
            end
            # Create if nil
            if @projectsfeature.nil?
                insert = params[:data][:status] == 1 ? "'#{@user.id}'" : "'#{@user.id}','#{@user.id}',now()"
                sql = "INSERT INTO features_projects VALUES (#{params[:data][:feature_id]},#{params[:data][:project_id]},#{params[:data][:status]},'#{params[:data][:commentaire]}',now(),'#{params[:data][:commentaire_prof]}',#{insert})"
            # Update else
            else
                setValidateInfos = params[:data][:status] == 2 ? ", date_badge_valide = now(), id_prof_valide = #{current_user.id}" : ""
                update = "status = #{params[:data][:status]}, commentaire = '#{params[:data][:commentaire]}', commentaire_prof = '#{params[:data][:commentaire_prof]}'" + setValidateInfos
                sql = "UPDATE features_projects SET #{update} WHERE feature_id = #{params[:data][:feature_id]} AND project_id = #{params[:data][:project_id]}"
            end
            render text: sql
            # Execute the query
            ActiveRecord::Base.connection.execute sql
        elsif @project.update(project_params)
            # On récupère tout les features associés
            allFeatureProject = FeaturesProject.select('feature_id').where(['project_id=?', @project.id])
            # On parcourt le tout
            allFeatureProject.each do |id|
                # On récupère le contenu actuelle
                @projectsfeature = FeaturesProject.where(['project_id=? and feature_id=?', @project.id, id.feature_id]).first
                update = 'status = 2'
                # On met a jour l'update si besoin
                if @projectsfeature.date_badge_valide.nil?
                    update += ",date_badge_valide = now(),id_prof_valide = #{current_user.id},date_demande = now()"
                end
                # Mise a jour de l'élément
                sql = "UPDATE features_projects SET #{update} WHERE feature_id = #{@projectsfeature.feature_id} AND project_id = #{@projectsfeature.project_id}"
                ActiveRecord::Base.connection.execute sql
            end
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

    # Méthode qui gère l'autocomplétion des champs multivalués
    def autocomplete_feature
        if params[:term]
            @autocomplete_values = ''
            if params[:type] == 'users_projects'
                @autocomplete_values = User.where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?', "%#{params[:term].downcase}%", "%#{params[:term].downcase}%", "%#{params[:term].downcase}%")
            elsif params[:type] == 'features_projects'
                @autocomplete_values = Feature.where('name ILIKE ?', "%#{params[:term].downcase}%")
            end
            respond_to do |format|
                format.html
                format.json { render json: @autocomplete_values.as_json(only: [:id], methods: [:name_for_associated_inuts]) }
            end
        end
    end

    # Méthode qui affiche la modal pour ajouter des éléments depuis la liste dans des champs multivalués
    def get_add_from_list_modal
        @project = if params[:id].nil?
                       Project.new
                   else
                       Project.find(params[:id])
                   end
        unless params[:label].nil? || params[:input_class].nil?
            @label = params[:label]
            @input_class = params[:input_class]
            render partial: 'associated_inputs_modal'
        end
    end

    # Methode qui vérifie si l'utilisateur est assigné au projet
    helper_method :user_assigned_to_project
    def user_assigned_to_project(project_id)
        if UsersProject.where('project_id=? and user_id=?', project_id, current_user.id).count > 0
            true
        else
            false
        end
    end

    def assignUserToProject
        # On assigne l'utilisateur connecté au projet dans la table users_projects
        @userProject = UsersProject.new(user_id: current_user.id, project_id: params[:id])
        if @userProject.save
            flash[:success] = 'Vous avez été assigné au projet !'
            redirect_to project_url
        end
    end

    #Méthode de recherche des features en fonction de son nom ou du nom du field auquel elle appartient
    def search_features
        unless params[:search].nil? && params[:project_id].nil?
            @project = Project.find(params[:project_id])
            @fields = Field.all
            @features = Feature.where("field_id in (SELECT id from fields where lower(name) LIKE lower('%#{params[:search]}%')) OR lower(name) LIKE lower('%#{params[:search]}%')")
            respond_to do |format|
                format.json { render :json => {:success => true, :html => (render_to_string(:partial => 'fields/list_ajax', :formats=>[:html]))} }
            end
        else
            respond_to do |format|
                format.json { render :json => {:success => false} }
            end
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
