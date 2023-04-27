Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "teams#index"

  namespace :api do
    # Teams
    resources :teams do
      get "/members", to: "teams#members"
    end

    # Projects
    resources :projects do
      get "/members", to: "projects#members"
      get "/members/add_project_member", to: "projects#add_project_member"
      post "/members/:id/create_project_member", to: "projects#create_project_member", as: :member_create_project_member
    end

    # Members
    resources :members do
      patch "/teams/:id", to: "members#update_team"
    end
  end
end
