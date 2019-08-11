require 'rails_helper'

RSpec.describe "CustomersController", type: :request do
    it "registers a customer successfully" do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer = { "firstName" => "Ryan", "lastName" => "Tashiro", "email" => "rtashiro-evans@csumb.edu" }
        
        post '/customers', :params => customer.to_json, :headers => headers
        expect(response).to have_http_status(201)
        customer_response = JSON.parse(response.body)
        expect(customer_response).to include customer
        
        customer = Customer.find_by(email: "rtashiro-evans@csumb.edu")
        expect(customer).to be_truthy
        expect(customer.email).to eq 'rtashiro-evans@csumb.edu'
    end
    
    it 'duplicate emails should fail' do
         headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer1 = { "firstName" => "Ryan", "lastName" => "Tashiro", "email" => "rtashiro-evans@csumb.edu" }
        Customer.create(firstName: "Robert", lastName: "Evans", email: "rtashiro-evans@csumb.edu")
        post '/customers', :params => customer1.to_json, :headers => headers
        expect(response).to have_http_status(400)
    end
    
    it 'missing values should fail' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer = {'firstName' => 'Ryan'}
        post '/customers', :params => customer.to_json, :headers => headers
        expect(response).to have_http_status(400)
    end
    
    it 'retrieve customer by id functions' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer = Customer.create(firstName: "Robert", lastName: "Evans", email: "rtashiro-evans@csumb.edu")
        get '/customers?id=1', :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['id']).to eq customer.id
        expect(customer_response['email']).to eq customer.email
    end
    
    it 'retrieve customer by invalid id should fail' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        get '/customers?id=100', :headers => headers
        expect(response).to have_http_status(404)
    end
    
    it 'retrieve customer by email functions' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer = Customer.create(firstName: "Robert", lastName: "Evans", email: "ace@gmail.com")
        get '/customers?email=ace@gmail.com', :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['id']).to eq customer.id
        expect(customer_response['email']).to eq customer.email
    end
    
    it 'retrieve customer by invalid email should fail' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        get '/customers?email=random@email.com', :headers => headers
        expect(response).to have_http_status(404)
    end
    
    it 'customer receives award after making 3 purchases' do
        headers = { "CONTENT_TYPE" => "application/json", 
                    "ACCEPT" => "application/json"}
        customer = Customer.create(firstName: "Robert", lastName: "Evans", email: "ace@gmail.com", lastOrder1: 0, lastOrder2: 0, lastOrder3: 0, award: 0)
        order1 = {id:1, customerId: customer.id, itemId: 1, price: 250.00, award: 0.0, total: 250.00}
        
        put '/customers/order', :params => order1.to_json, :headers => headers
        expect(response).to have_http_status(204)
        
        get "/customers?id=#{customer.id}", :headers => headers
        expect(response).to have_http_status(200)
        
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder1']).to eq 250
        expect(customer_response['lastOrder2']).to eq 0
        expect(customer_response['lastOrder3']).to eq 0
        
        
        order2 = {id:2, customerId: customer.id, itemId: 2, price: 120.00, award: 0.0, total: 120.00}
        put '/customers/order', :params => order2.to_json, :headers => headers
        expect(response).to have_http_status(204)
        get "/customers?id=#{customer.id}", :headers => headers
        expect(response).to have_http_status(200)
        
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder1']).to eq 120
        expect(customer_response['lastOrder2']).to eq 250
        expect(customer_response['lastOrder3']).to eq 0
        
        
        order3 = {id:3, customerId: customer.id, itemId: 3, price: 490.00, award: 0.0, total: 490.00}
        put '/customers/order', :params => order3.to_json, :headers => headers
        expect(response).to have_http_status(204)
        get "/customers?id=#{customer.id}", :headers => headers
        expect(response).to have_http_status(200)
        
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 28.67
        expect(customer_response['lastOrder1']).to eq 490
        expect(customer_response['lastOrder2']).to eq 120
        expect(customer_response['lastOrder3']).to eq 250
        
        order4 = {id:4, customerId: customer.id, itemId: 4, price: 200, award: 28.67, total: 171.33}
        put '/customers/order', :params => order4.to_json, :headers => headers
        expect(response).to have_http_status(204)
        get "/customers?id=#{customer.id}", :headers => headers
        expect(response).to have_http_status(200)
        
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder1']).to eq 0
        expect(customer_response['lastOrder2']).to eq 0
        expect(customer_response['lastOrder3']).to eq 0
    end
end
