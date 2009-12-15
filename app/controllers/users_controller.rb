class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :find_user_by_permalink, :only => [:edit, :update]
  
  def show
    @user = User.find_by_permalink(params[:id])
  end

  def new
    @user = User.new
  end  

  def create
    logout_keeping_session!
    open_id_authentication(params[:openid_identifier])
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      # Show success or an error message on the same edit page
      flash[:notice] = "Your profile has been updated!"
      redirect_to edit_user_path
    else
      render :action => :edit
    end
  end
  
  protected

  def find_user_by_permalink
    @user = User.find_by_permalink(params[:id], :include => :emails)
  end

  def open_id_authentication(identity_url)
    # Pass optional :required and :optional keys to specify what sreg fields you want.
    # Be sure to yield registration, a third argument in the #authenticate_with_open_id block.
    authenticate_with_open_id(identity_url, :return_to => open_id_create_url,
        :required => [], :optional => [:nickname, :email, :fullname]) do |result, identity_url, registration|
      case result.status
      when :missing
        failed_creation "Sorry, the OpenID server couldn't be found"
      when :invalid
        failed_creation "Sorry, but this does not appear to be a valid OpenID"
      when :canceled
        failed_creation "OpenID verification was canceled"
      when :failed
        failed_creation "Sorry, the OpenID verification failed"
      when :successful
        # Check for existing identity
        if self.current_user = User.find_by_identity_url(identity_url)
          successful_login
        else
          create_new_user(:identity_url => identity_url, :username => registration['nickname'], :email => registration['email'])
        end
      end
    end
  end
  
  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user.save
      self.current_user = @user
      successful_creation
    else
      failed_creation
    end
  end
  
  def successful_creation
    redirect_back_or_default(edit_user_url(current_user))
    flash[:notice] = "Thanks for signing up!"
  end
  
  def successful_login
    #handle_remember_cookie! new_cookie_flag
    redirect_back_or_default(user_url(current_user))
    flash[:notice] = "Logged in successfully"
  end
  
  def failed_creation(message = 'Sorry, there was an error creating your account')
    @user = User.new
    flash[:error] = message
    render :action => :new
  end
end
