class CommandController < ApplicationController
	def resetDB
		system("sh resetDB.sh")
		render :json => "reset DB finished.".to_json
	end
end
