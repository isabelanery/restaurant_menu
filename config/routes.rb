Rails.application.routes.draw do
  namespace :api do
    resources :menus do
      resources :menu_items, only: %i[index show]
    end
  end
end
