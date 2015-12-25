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
			@message[:statuses] = statuses
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
	def getRequirementById
		requirement = Requirement.find_by(:id => params[:rid])
		if requirement.nil?
			@message[:result] = "failed"
			@message[:message] = "requirement is not found."
		else
			@message[:result] = "success"
			@message[:requirement] = requirement
		end
		render :json => requirement.to_json
		
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
		render :json => @message.as_json(include: [:priority_type, :status_type,:requirement_type,:project],except: [:updated_at])
	end
	def new
		params = get_require_params
		user = User.find_by(:id =>params[:uid])
		project = Project.find_by(:id => params[:pid])
		handler = User.find_by(:id => params[:handler])
		
		params.delete(:uid)
		params.delete(:pid)
		params.delete(:handler)
		params[:owner] = user
		params[:project] = project
		params[:handler] = handler
		requirement = Requirement.new(params)
		
		if requirement.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end

	def update
		params = get_update_require_params
		user = User.find(params[:uid])
		project = Project.find(params[:pid])
		handler = User.find_by(:id => params[:handler])
		requirement = Requirement.find(params[:id])

		params.delete(:id)
		params.delete(:uid)
		params.delete(:pid)
		params.delete(:handler)

		params[:owner] = user
		params[:project] = project
		params[:handler] = handler

		if requirement.update(params)
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json

	end
	def delete
		requirement = Requirement.find_by(:id => params[:rid])
		if requirement.nil?
			@message[:result] = "failed"
			@message[:message] = "requirement not found."
		else
			requirement_test_ships = RequirementTestCaseship.where(:requirement => requirement)

			if requirement_test_ships.size > 0
				requirement_test_ships.each do |requirement_test_ship|
					requirement_test_ship.delete
				end
			end
			if requirement.delete
				@message[:result] = "success"
			else
				@message[:result] = "failed"
				@message[:message] = "requirement delete failed."
			end
		end
		render :json => @message.to_json
	end


	def getNoAssociatedRequirementByProjectId
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "project not found."
		else
			requirement = RequirementRequirementship.where(:project => project)
			requirement_list = Requirement.where(
					"id not in(?)",requirement.map{|r| r.requirement1}).where(
					"id not in(?)",requirement.map{|r| r.requirement2})
			@message[:result] = "success"
			@message[:requirement_list] = requirement_list
		end
		render :json => @message.as_json(include: [:priority_type, :status_type,:requirement_type,:project],except: [:updated_at])

	end

	def newRtoRRelation
		params = get_r_to_r_params
		project = Project.find_by(:id => params[:pid])
		requirement_1 = Requirement.find_by(:id => params[:r1id])
		requirement_2 = Requirement.find_by(:id => params[:r2id])
		rrship = RequirementRequirementship.new
		rrship.project = project
		rrship.requirement1 = requirement_1
		rrship.requirement2 = requirement_2

		if rrship.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
			@message[:message] = "Create requirement to requirement ship failed."
		end

		render :json => @message.to_json


	end

	def getRtoRRelationByProjectId
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "Project not found."
		else
			r_r_ships = RequirementRequirementship.select(:id,:project_id,:requirement1_id,:requirement2_id).where(:project => project).order("requirement1_id,requirement2_id")
			@message[:result] = "success"
			@message[:rr_relations] = r_r_ships
		end
		render :json => @message.to_json
	end



	def deleteRtoRRelationByProjectId
		project = Project.find_by(:id => params[:pid])
		if project.nil?
			@message[:result] = "failed"
			@message[:message] = "Project not found."
		else
			r_r_ships = RequirementRequirementship.where(:project => project)
			if r_r_ships.nil?
				@message[:result] = "failed"
				@message[:message] = "relation not found."
			else
				r_r_ships.each do |r_r_ship|
					r_r_ship.delete
				end
				@message[:result] = "success"
			end
		end
		render :json => @message.to_json
	end

	def getRequirementListByTestCaseId
		test_case = TestCase.find_by(:id => params[:pid])
		if test_case.nil?
			@message[:result] = "failed"
			@message[:message] = "Test case not found."
		else
			requirement_test_case_ships  = RequirementTestCaseship.select(:requirement_id).where(:test_case => test_case)
			requirement_list = Requirement.where(:id => requirement_test_case_ships)
			@message[:result] = "success"
			@message[:requirements] = requirement_list
		end
		render :json => @message.as_json(include: [:priority_type, :status_type,:requirement_type,:project],except: [:updated_at])
	end

  private
	def get_require_params
		params.permit(:name, :description, :version, :memo, :handler, :uid, :pid, :requirement_type_id, :priority_type_id, :status_type_id)
	end

	def get_update_require_params
		params.permit(:id, :name, :description, :version, :memo, :handler, :uid, :pid, :requirement_type_id, :priority_type_id, :status_type_id)
	end

	def get_r_to_r_params
		params.permit(:pid,:r1id,:r2id)
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
