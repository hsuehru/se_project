class UserController < ApplicationController
	skip_before_filter :verify_authenticity_token
	after_action :access_control_headers

	before_action :new_hash

	def test
		param = get_test_param
		#@a = param.to_json
		system('ls -l')
		render :json => param.to_json
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
