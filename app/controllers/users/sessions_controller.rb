class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:new, :create, :destroy, :omniauth, :failure]
  def create
    Rails.logger.info "Login attempt for email: #{params[:user][:email]}"

    user = User.find_by(email: params[:user][:email])
    if user.nil?
      Rails.logger.info "User not found"
    elsif !user.valid_password?(params[:user][:password])
      Rails.logger.info "Invalid password for user #{user.email}"
    else
      Rails.logger.info "Login successful for user #{user.email} with role #{user.role}"
    end

    super
  end
    # def omniauth
    #   user = User.from_omniauth(request.env['omniauth.auth'])
      
    #   if user.persisted?
    #     sign_in user
    #     redirect_to root_path, notice: "Signed in successfully with Google!"
    #   else
    #     redirect_to new_user_registration_path, alert: "There was an issue signing in with Google."
    #   end
    # end

    #NEW GPT

    def omniauth
      auth = request.env['omniauth.auth']
      
      # Example: Find or create a user
      user = User.find_or_create_by(email: auth['info']['email']) do |u|
        u.name = auth['info']['name']
        u.image = auth['info']['image']
        u.provider = auth['provider']
        u.uid = auth['uid']
      end
  
      if user.persisted?
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully!'
      else
        redirect_to root_path, alert: 'Failed to log in!'
      end
    end
  
    def failure
      redirect_to root_path, alert: 'Authentication failed.'
    end
  
  
end

