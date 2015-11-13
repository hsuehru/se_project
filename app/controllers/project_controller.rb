class ProjectController < ApplicationController
	skip_before_filter :verify_authenticity_token
	after_action :access_control_headers

	before_action :new_hash

	def new
		params = get_project_params
		project = Project.new
		user = User.find(params[:uid])
		project = user.projects.create(:name => params[:name], :descript => params[:descript])
		#project.descript = params[:descript]
		project.owner = user
		#project.name = params[:name]
		if project.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end
	def list
		user = User.find(params[:uid])
		projects = user.projects
		@message[:result] = "success"
		@message[:projects] = projects
		render :json => @message.to_json
	end

	def register
		params = get_register_params
		user = User.new(params)
		if user.save
			@message[:result] = "success"
		else
			@message[:result] = "failed"
		end
		render :json => @message.to_json
	end
	
	def login
		params = get_login_params
		user = User.find_by(:email => params[:email])
		if user == nil
			@message[:result] = "failed"
			@message[:error_message] = "No User"
		else
			if user.authenticate(params[:password])
				@message[:result] = "success"
				@message[:name] = user.name
				@message[:uid] = user.id
			else
				@message[:result] = "failed"
				@message[:error_message] = "Wrong password"
			end
		end
		render :json => @message.to_json
	end


  private
	def get_test_param
		params.permit(:account,:password)
	end

	def get_project_params
		params.permit(:name, :descript, :uid)
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
