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
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "project not found."
		else
			user_projectships = UserProjectship.select(:user_id,:user_project_priority_id).where(:project => project).order("user_project_priority_id, created_at")
			# users = project.users
			users = Array.new
			if !user_projectships.nil?
				user_projectships.each do |user_project_ship|
					user = {:id => user_project_ship.user.id,
									:name => user_project_ship.user.name,
									:priority_type_id => user_project_ship.user_project_priority.id,
									:priority_type_name => user_project_ship.user_project_priority.name}
					users.append(user)
				end
			end
			@message[:result] = "success"
			# @message[:users] = users

			@message[:users] = users

		end

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
				if user_project_priority.nil?
					user_project.user_project_priority = UserProjectPriority.find_by(:name => "Member")
				else
					user_project.user_project_priority = user_project_priority
				end

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
					@message[:message] = "The user already exists in project."
				end
			end
		else
			@message[:result] = "failed"
			@message[:message] = "you are not project owner."
		end
		render :json => @message.to_json
	end

	def deleteUserFromProject
		params = get_delete_user_from_project_params
		project = Project.find_by(:id =>  params[:pid])
		user = User.find_by(:id =>  params[:uid])

		user_project_ship = UserProjectship.find_by(:project => project, :user => user)

		if user_project_ship.nil?
			@message[:result] = "failed"
			@message[:message] = "user not exists project."
		else
			if user_project_ship.delete
				@message[:result] = "success"
			else
				@message[:result] = "failed"
				@message[:message] = "delete failed."
			end
		end
		render :json => @message.to_json
	end

	def changeUserPriority
		params = get_change_user_priority_params
		project = Project.find_by(:id =>  params[:pid])
		user = User.find_by(:id =>  params[:uid])
		priority_type = UserProjectPriority.find_by(:id => params[:priority_type_id])
		user_project_ship = UserProjectship.find_by(:project => project, :user => user)
		if user_project_ship.nil?
			@message[:result] = "failed"
			@message[:message] = "user not exists project."
		else
			user_project_ship.user_project_priority = priority_type
			if user_project_ship.save
				@message[:result] = "success"
			else
				@message[:result] = "failed"
				@message[:message] = "change priority failed."
			end
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
	def get_delete_user_from_project_params
		params.permit(:pid, :uid)
	end
	def get_change_user_priority_params
		params.permit(:pid ,:uid, :priority_type_id)
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
