class FeaturesProjectController < ApplicationController
	authorize_resource
	# POST /FeaturesProject
	def create
		@projectsfeature = FeaturesProject.new(project_params)

		if @projectsfeature.save
		  redirect_to @projectsfeature, notice: 'Project Feature was successfully created.'
		else
		  render :new
		end
	end
	def features_project_params
	    params.require(:featuresproject).permit(:feature_id,:project_id,:status,:commentaire)
	end
 end