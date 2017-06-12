# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :user_managers, only: [:new, :create, :index, :destroy]
namespace 'user_manager', module: nil do
  resources :users, only: [:new, :create, :index], controller: :user_manager_users
end
