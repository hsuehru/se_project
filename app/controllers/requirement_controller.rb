class RequirementController < ApplicationController
	skip_before_filter :verify_authenticity_token
	after_action :access_control_headers

	before_action :new_hash


	def getPriorityType
		priorities = PriorityType.select(:id,:name).all
		if priorities.size == 0
			@message[:result] = "failed"
		else
			@message[:result] = "success"
			@message[:priority] = priorities
		end
		render :json => @message.to_json
	end
	def getStatusType
		statuses = StatusType.select(:id,:name).all
		if statuses.size == 0
			@message[:result] = "failed"
		else
			@message[:result] = "success"
			@message[:priority] = statuses
		end
		render :json => @message.to_json
	end


	def getRequirementType
		requirementTypes = RequirementType.select(:id,:name).all
		if requirementTypes.size == 0
			@message[:result] = "failed"
		else
			@message[:result] = "success"
			@message[:type] = requirementTypes
		end
		render :json => @message.to_json
	end
	def getRequirementByProject
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "Project is not found."
		else
			@message[:result] = "success"
			@message[:requirements] = project.requirements
		end
		render :json => @message.to_json
	end
	def new
		params = get_require_params
		user = User.find(params[:uid])
		project = Project.find(params[:pid])
		
		params.delete(:uid)
		params.delete(:pid)
		params[:owner] = user
		params[:project] = project
		requirement = Requirement.new(params)
		
		if requirement.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end
	

  private
	def get_test_param
		params.permit(:account,:password)
	end

	def get_require_params
		params.permit(:name, :description, :version, :memo, :uid, :pid, :requirement_type_id, :priority_type_id, :status_type_id)
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
