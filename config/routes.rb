Tsa::Application.routes.draw do
  match 'access_denied' => 'errors#access_denied', :as => :access_denied
  get 'pictures/index'

  devise_for :users
  resources :users, :only => [:edit, :update, :show]

  match 'users/edit/password/:id(.:format)' => 'users#edit_password', :as => :edit_password
  match 'users/update/password/:id(.:format)' => 'users#update_password', :as => :update_password
  match 'users/new/partner' => 'users#new_partner', :as => :new_partner_registration
  post 'users/partner' => 'users#create_partner', :as => :partner_registration
  match 'users/partner/welcome' => 'users#welcome_partner', :as => :welcome_partner
  match 'partner/:id/pois' => 'users#pois', :as => :partner_pois
  match 'request/:id/ownership' => 'users#request_ownership', :as => :request_ownership

  match 'admin/users/:id/allow_ownership' => 'admin/users#allow_ownership', :as => :admin_allow_ownership
  match 'admin/users/:id/deny_ownership' => 'admin/users#deny_ownership', :as => :admin_deny_ownership
  delete 'admin/users/:id/destroy_ownership' => 'admin/users#destroy_ownership', :as => :admin_destroy_ownership

  get 'admin/apn/devices' => 'admin/apn#devices', :as => :admin_devices
  get 'admin/apn/new' => 'admin/apn#new', :as => :admin_new_apn
  post 'admin/apn/create' => 'admin/apn#create', :as => :admin_create_apn
  get 'admin/apn/notifications' => 'admin/apn#notifications', :as => :admin_apn_notifications
  delete 'admin/apn/:id/notifications' => 'admin/apn#destroy', :as => :admin_destroy_apn

  match '/brunei' => 'countries#show', :id => 110
  match '/brunei/*type' => 'countries#list', :id => 110
  match '/cambodia' => 'countries#show', :id => 108
  match '/cambodia/*type' => 'countries#list', :id => 108
  match '/hong_kong' => 'countries#show', :id => 111
  match '/hong_kong/*type' => 'countries#list', :id => 111
  match '/indonesia' => 'countries#show', :id => 105
  match '/indonesia/*type' => 'countries#list', :id => 105
  match '/laos' => 'countries#show', :id => 104
  match '/laos/*type' => 'countries#list', :id => 104
  match '/malaysia' => 'countries#show', :id => 101
  match '/malaysia/*type' => 'countries#list', :id => 101
  match '/myanmar' => 'countries#show', :id => 106
  match '/myanmar/*type' => 'countries#list', :id => 106
  match '/philippines' => 'countries#show', :id => 103
  match '/philippines/*type' => 'countries#list', :id => 103
  match '/singapore' => 'countries#show', :id => 109
  match '/singapore/*type' => 'countries#list', :id => 109
  match '/taiwan' => 'countries#show', :id => 102
  match '/taiwan/*type' => 'countries#list', :id => 102
  match '/thailand' => 'countries#show', :id => 100
  match '/thailand/*type' => 'countries#list', :id => 100
  match '/vietnam' => 'countries#show', :id => 107
  match '/vietnam/*type' => 'countries#list', :id => 107
  match '/china' => 'countries#show', :id => 112
  match '/china/*type' => 'countries#list', :id => 112
  match '/japan' => 'countries#show', :id => 113
  match '/japan/*type' => 'countries#list', :id => 113
  match '/south_korea' => 'countries#show', :id => 114
  match '/south_korea/*type' => 'countries#list', :id => 114
  match '/macau' => 'countries#show', :id => 115
  match '/macau/*type' => 'countries#list', :id => 115
  match '/india' => 'countries#show', :id => 116
  match '/india/*type' => 'countries#list', :id => 116
  match '/sri_lanka' => 'countries#show', :id => 117
  match '/sri_lanka/*type' => 'countries#list', :id => 117

  get 'home/index'
  match '/map' => 'home#fullmap', :as => :fullmap
  match '/beta_testing' => 'home#beta_testing'
  match '/privacy_policy' => 'home#privacy_policy'

  match '/tours' => 'home#list', :type => :tours
  match '/attractions' => 'home#list', :type => :attractions
  match '/hotels' => 'home#list', :type => :hotels
  match '/promos' => 'home#list', :type => :promos

  root :to => 'home#index'

  resources :countries, :only => [:index, :show] do
    resources :destinations, :only => [:index, :show]
  end

  resources :destinations, :only => [:index, :show] do
    resources :pois, :only => [:index, :show]
  end

  resources :pois, :only => [:index, :show]

  match 'bookings/mobile' => 'bookings#mobile'
  resources :bookings, :except => [:update, :destroy]

  resources :supports, :only=> [:new, :create]
  match 'contact' => 'supports#new', :as => :contact_us

  match 'search' => 'pois#search', :as => :search
  match 'nearby' => 'pois#nearby', :as => :nearby
  match 'recent' => 'pois#recent', :as => :recent
  match 'featured' => 'pois#featured', :as => :featured
  match 'most_viewed' => 'pois#most_viewed', :as => :most_viewed
  match 'pois/:id/like' => 'pois#like', :as => :like_poi
  match 'pois/:id/unlike' => 'pois#unlike', :as => :unlike_poi
  match 'feed' => 'pois#feed', :as => :feed

  get 'mobileupdates' => 'mobile#updates', :as => :mobileupdates
  get 'mobile/buttons' => 'mobile#buttons'
  get 'mobile/destinations' => 'mobile#destinations'
  get 'mobile/ads' => 'mobile#ads'
  get 'mobile/adsense' => 'mobile#adsense'
  get 'mobile/country_overview' => 'mobile#country_overview'
  get 'mobile/country_description' => 'mobile#country_description'
  get 'mobile/register' => 'mobile#register'

  match 'check_rates' => 'partner_hotels#check_rates'
  match 'partner_hotels/:id/save_rooms' => 'partner_hotels#save_rooms'

  resources :comments, :only => [:create, :update]
  post 'comments/:id' => 'comments#destroy'

  namespace 'admin' do

    resources :countries
    resources :destinations

    match 'pois/ownerships' => 'pois#ownerships', :as => :poi_ownerships
    resources :pois, :except => [:show]

    resources :pictures
    match 'pictures/:id/update_default' => 'pictures#update_default', :as => :update_default_picture
    resources :web_photos
    resources :descriptions
    resources :description_types
    resources :destination_types
    resources :poi_types

    resources :partner_hotels, :only => [:destroy, :edit, :update, :show]
    get 'partner_hotels/:id/fetch_rooms' => 'partner_hotels#fetch_rooms', :as => :partner_hotel_fetch_rooms

    resources :bookings, :only => [:index, :show, :destroy, :update]
    resources :supports, :only=> [:index, :show, :destroy]
    resources :users, :only => [:index]

    get 'dashboard/index', :as => :dashboard

    root :to => 'dashboard#index'
  end

  match 'ajax/destinations' => 'ajax#destinations'

  match '*a', :to => 'errors#404'

end
