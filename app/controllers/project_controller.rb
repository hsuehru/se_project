class ProjectController < ApplicationController
	skip_before_filter :verify_authenticity_token
	after_action :access_control_headers

	before_action :new_hash

	def new
		params = get_project_params
		project = Project.new
		user = User.find(params[:uid])
		project = user.projects.create(:name => params[:name], :description => params[:description])
		#project.descript = params[:descript]
		#project.name = params[:name]
		project.owner = user
		if project.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end
	def getProjectListByUser
		user = User.find(params[:uid])
		projects = user.projects
		@message[:result] = "success"
		@message[:projects] = projects
		render :json => @message.to_json
	end
	def getUserListByProject
		project = Project.find(params[:uid])
		users = project.users
		@message[:result] = "success"
		@message[:users] = users
		render :json => @message.to_json
	end
	def addUserToProject
		user_project_type = UserProjectType.select(:id,:name).find([2,3,4])
		params = get_add_user_to_project_params
		project = Project.find(params[:pid])
		owner = User.find(params[:uid])
		if project.owner == owner
			user = User.find_by(:email =>params[:add_email])
			if user.nil?
				@message[:result] = "failed"
	      @message[:message] = "User not exist."
			else
				user_project = UserProjectship.new
				user_project.user = user
				user_project.project = project
				if user_project.save
					@message[:result] = "success"
				else
					@message[:result] = "failed"
					@message[:message] = "Add user to project failed."
				end
			end
		else
			@message[:result] = "failed"
			@message[:message] = "you are not project owner."
		end
		render :json => @message.to_json
	end

  private
	def get_test_param
		params.permit(:account,:password)
	end
	def get_add_user_to_project_params
		params.permit(:add_email, :uid, :pid)
	end

	def get_project_params
		params.permit(:name, :description, :uid)
	end

	def get_register_params
		params.permit(:email,:password,:name)
	end
	def get_login_params
		params.permit(:email,:password)
	end
########################################################################################################
	def new_hash
		@message = Hash.new
	end

	def access_control_headers
		headers['Access-Control-Allow-Origin'] = "*"
		headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
	end
end
