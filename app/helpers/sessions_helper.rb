module SessionsHelper

	def sign_in(user)
		session[:session_token] = user.session_token
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		@current_user = nil
		session.delete(:session_token)
	end

	def current_user
		@current_user ||= User.find_by_session_token(session[:session_token])
	end

#--------0831
	def current_user?(user)
	    user == current_user
	end

    def authenticate_user
        unless signed_in?
        flash[:notice] = "Sign-in to continue"
            redirect_to new_sessions_path
        end
    end

end
