Redmine::Plugin.register :user_manager do
  name 'User Manager plugin'
  author 'Gabriel Cardoso'
  description 'This is a plugin allowing user to create other users'
  version '0.0.1'

  menu :admin_menu, :user_managers, {
    :controller => 'user_managers', :action => 'index'
  }, :caption => :label_user_manager_plural

  menu :top_menu, :users, {
    :controller => 'user_manager_users', :action => 'index'
  }, :caption => :label_user_plural, :if => Proc.new {
    !User.current.admin? && UserManager.exists?(user: User.current)
  }
end
