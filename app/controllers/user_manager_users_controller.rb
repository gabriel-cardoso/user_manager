class UserManagerUsersController < ApplicationController
  helper :users
  include UsersHelper
  helper :sort
  include SortHelper
  helper :custom_fields
  include CustomFieldsHelper
  helper :principal_memberships

  def create
    @user = User.new(:language => Setting.default_language, :mail_notification => Setting.default_notification_option)
    @user.safe_attributes = params[:user]
    @user.admin = false
    @user.login = params[:user][:login]
    @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation] unless @user.auth_source_id
    @user.pref.attributes = params[:pref] if params[:pref]

    if @user.save
      Mailer.account_information(@user, @user.password).deliver if params[:send_information]

      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_user_successful_create, :id => view_context.link_to(@user.login, user_path(@user)))
          if params[:continue]
            attrs = params[:user].slice(:generate_password)
            redirect_to new_user_manager_user_path(:user => attrs)
          else
            redirect_to user_manager_users_path
          end
        }
        format.api  { render :action => 'show', :status => :created, :location => user_url(@user) }
      end
    else
      @auth_sources = AuthSource.all
      # Clear password input
      @user.password = @user.password_confirmation = nil

      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@user) }
      end
    end
  end

  def new
    @auth_sources = AuthSource.all
    @user = User.new
  end

  def index
    scope = User.logged.preload(:email_address)

    @limit = per_page_option
    @user_count = scope.count
    @user_pages = Paginator.new @user_count, @limit, params['page']
    @offset ||= @user_pages.offset
    @users =  scope.limit(@limit).offset(@offset).to_a
  end

  private

  def user_params
    params.require(:user).permit(:firstname)
  end
end
