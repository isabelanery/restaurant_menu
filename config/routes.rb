Rails.application.routes.draw do
  namespace :api do
    resources :restaurants, only: %i[index show] do
      resources :menus, only: %i[index show]
    end

    resources :menu_items, only: %i[index show]
  end
end
