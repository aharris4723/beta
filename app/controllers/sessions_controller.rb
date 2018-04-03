class SessionsController < ApplicationController
	def new
	end
	
	def create
		@user = User.find_by_email(params[:email])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id 
			flash[:message] = 'you logged in successfully'
			redirect_to '/users'
		else 
			flash[:message] = 'try again'
			redirect_to '/login'
		end
	end


	def destroy
		session[:user_id] = nil
		flash[:message] = 'logging out ok'
		redirect_to '/login'
	end

end