Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace "v1", defaults: { format: 'json'} do
    # Users
    resources :users do
      collection do
        get 'login'
        get 'query_scope'
        get 'vacation_per_year/:id' => 'users#vacation_per_year'
      end
    end

    # Vacations
    resources :vacations do
      collection do
        get 'have_by_user', to: 'vacations#vacation_have_by_user'
        get 'had_by_user', to: 'vacations#vacation_had_by_user'
      end
    end

    # Leaders	
    resources :leaders
  end
end
