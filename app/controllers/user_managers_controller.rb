class UserManagersController < ApplicationController
  layout 'admin'
  unloadable

  def create
    @user_manager = UserManager.new user_manager_params
    if @user_manager.save
      flash[:notice] = t('notice_successful_create')
    end
    redirect_to :action => 'index'
  end

  def new
    @user_manager = UserManager.new
    @users = User.all
  end

  def index
    @user_managers = UserManager.all
  end

  def destroy
    @user_manager = UserManager.find(params[:id])
    if @user_manager.destroy
      flash[:notice] = t('notice_successful_delete')
    end
    redirect_to :action => 'index'
  end

  private

  def user_manager_params
    params.require(:user_manager).permit(:user_id)
  end
end
