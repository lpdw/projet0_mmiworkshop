class UsersProjectController < ApplicationController
	authorize_resource
	# POST /UsersProject
	def create
		@projectsuser = UsersProject.new(project_params)

		if @projectsuser.save
		  redirect_to @projectsuser, notice: 'Project User was successfully created.'
		else
		  render :new
		end
	end
	def users_project_params
	    params.require(:usersproject).permit(:user_id,:project_id,:group_id)
	end
 end