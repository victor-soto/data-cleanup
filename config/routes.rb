Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get 'csv_engine/lookup', to: 'csv_engine#lookup', as: 'csv_engine_lookup'
  post 'csv_engine/generate_lookup_csv', to: 'csv_engine#generate_lookup_csv', as: 'generate_lookup_csv'
  
  resources :lookup_csv, only: %i[new create]
  resources :documents, only: %i[index new create]
  post 'documents/upload_temp', to: 'documents#upload_temp', as:'upload_temp'

  post 'lookup_csv/upload', to: 'lookup_csv#upload', as: 'upload_csv'
  get 'lookup_csv/preview', to: 'lookup_csv#preview', as: 'preview_csv'

end
