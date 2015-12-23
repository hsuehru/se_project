class ProjectController < ApplicationController
	skip_before_filter :verify_authenticity_token
	after_action :access_control_headers

	before_action :new_hash

	def new
		params = get_project_params
		user = User.find(params[:uid])
		project = Project.new(:name => params[:name], :description => params[:description])
		ups = UserProjectship.new
		ups.project = project
		ups.user = user
		ups.user_project_priority = UserProjectPriority.find_by(:name => "Owner")
		if ups.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end

	def update
		params = get_update_project_params
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "The project doesn't exists."
		else
			project.name = params[:name]
			project.description = params[:description]
			if project.save
				@message[:result] = "success"
			else
				@message[:result] = "failed"
				@message[:message] = "Update failed."
			end

		end
		render :json => @message.as_json
	end

	def delete
		project = Project.find_by(:id => params[:pid])
		user_projectships = UserProjectship.where(:project => project)

		if user_projectships.size > 0
			user_projectships.each do |user_projectship|
				user_projectship.delete
			end
		end

		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "project can not found."
		else
			if project.delete
				@message[:result] = "success"
			else
				@message[:result] = "failed"
				@message[:message] = "delete failed."
			end
		end

		render :json => @message.as_json
	end

	# def delete
	# 	params = get_delete_project_params
	# 	project = User.find(1).projects.where(:id => params[:uid])
	# 	User.find().projects.delete(project)
	# end

	def getOwnerProjectListByUserId
		user = User.find_by(:id => params[:uid])
		project_list = user.user_projectships.where(:user_project_priority => UserProjectPriority.find_by(:name => "Owner")).map{|ups| ups.project}
		render :json => project_list.as_json
	end
	def getManagerProjectListByUserId
		user = User.find_by(:id => params[:uid])
		project_list = user.user_projectships.where(:user_project_priority => UserProjectPriority.find_by(:name => "Manager")).map{|ups| ups.project}
		render :json => project_list.as_json
	end
	def getMemberProjectListByUserId
		user = User.find_by(:id => params[:uid])
		project_list = user.user_projectships.where(:user_project_priority => UserProjectPriority.find_by(:name => "Member")).map{|ups| ups.project}
		render :json => project_list.as_json
	end
	def getCustomerProjectListByUserId
		user = User.find_by(:id => params[:uid])
		project_list = user.user_projectships.where(:user_project_priority => UserProjectPriority.find_by(:name => "Customer")).map{|ups| ups.project}
		render :json => project_list.as_json
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

	def getProjectPriorityType
		project_priority_types = UserProjectPriority.select(:id,:name).where("name != 'Owner'")
		render :json => project_priority_types.as_json
	end

	def addUserToProject
		params = get_add_user_to_project_params
		user_project_priority = UserProjectPriority.find_by(:id => params[:priority_type_id])
		#params.permit(:add_email, :uid, :pid, :priority_type_id)
		project = Project.find(params[:pid])
		user = User.find_by(:id => params[:uid])
		is_owner = user.user_projectships.find_by(:project => project, :user_project_priority => UserProjectPriority.find_by(:name => "Owner"))

		if !is_owner.nil?
			add_user = User.find_by(:email =>params[:add_email])
			if add_user.nil?
				@message[:result] = "failed"
	      @message[:message] = "User not exist."
			else
				user_project = UserProjectship.new
				user_project.user = add_user
				user_project.project = project
				user_project.user_project_priority = user_project_priority
				in_project = UserProjectship.find_by(:user => add_user , :project => project)
				if in_project.nil?
					if user_project.save
						@message[:result] = "success"
					else
						@message[:result] = "failed"
						@message[:message] = "Add user to project failed."
					end
				else
					@message[:result] = "failed"
					@message[:message] = "The user has in the project."
				end
			end
		else
			@message[:result] = "failed"
			@message[:message] = "you are not project owner."
		end
		render :json => @message.to_json
	end

  private
	def get_add_user_to_project_params
		params.permit(:add_email, :uid, :pid, :priority_type_id)
	end

	def get_update_project_params
		params.permit(:pid, :name, :description)
	end

	def get_delete_project_params
		params.permit(:pid, :uid)
	end

	def get_project_params
		params.permit(:name, :description, :uid)
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
