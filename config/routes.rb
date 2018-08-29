ALLOW_DOTS ||= /[^\/]+(?=\.(html|json|ttl)\z)|[^\/]+/

Rails.application.routes.draw do
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Spotlight::Engine, at: 'spotlight'
  resources :rights
  blacklight_for :catalog
  devise_for :users
  mount Hydra::Collections::Engine => '/'
  mount CurationConcerns::Engine, at: '/'
  resources :welcome, only: :index
  root to: 'welcome#index'
  #root to: "welcome#index" # replaced by spotlight root path
  iiif_for 'riiif/image', at: '/image-service'
  curation_concerns_collections
  curation_concerns_basic_routes
  curation_concerns_embargo_management
  resources :admin_sets, constraints: { id: ALLOW_DOTS } do
    member do
      get :confirm_delete
    end
  end

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:groups) && current_user.groups.include?('admin')
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque"
  end

  get 'collections/:id/allow_downloads' => 'collections#allow_downloads', as: :allow_downloads
  get 'collections/:id/prevent_downloads' => 'collections#prevent_downloads', as: :prevent_downloads
  get 'admin_sets/:id/allow_downloads' => 'admin_sets#allow_downloads', as: :admin_set_allow_downloads
  get 'admin_sets/:id/prevent_downloads' => 'admin_sets#prevent_downloads', as: :admin_set_prevent_downloads
end
