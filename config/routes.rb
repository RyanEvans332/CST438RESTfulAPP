Rails.application.routes.draw do
    get '/customers' => 'customers#get'
    post '/customers' => 'customers#create'
    put '/customers/order' => 'customers#processOrder'
end
