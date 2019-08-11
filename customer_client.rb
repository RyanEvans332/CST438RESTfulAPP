require 'httparty'

class CustomerClient
    include HTTParty
    base_uri "http://localhost:8080"
    format :json
    
    def self.newCustomer(cust)
        post '/customers', body: cust.to_json,
        headers:{'Content-Type' => 'application/json', 'ACCEPT' => 'application/json'}
    end
    
    def self.getById(id)
        get "/customers?id=#{id}"
    end
    
    def self.getByEmail(email)
        get "/customers?email=#{email}"
    end
end

while true
    puts "Do you want to: register, email, id, or quit?"
    user_input = gets.chomp
    case user_input
        when 'register'
            puts "Enter last name, first name, and email in order:"
            custData = gets.chomp!.split()
            response = CustomerClient.newCustomer lastName: custData[0], firstName: custData[1], email: custData[2]
            puts "status #{response.code}"
            puts response.body
            
        when 'email'
            puts "Enter email for customer lookup:"
            custData = gets.chomp!
            p custData
            response = CustomerClient.getByEmail(custData)
            if response.code == 404
                puts "customer not found!"
            else
                puts "status #{response.code}"
                puts response.body
            end
        
        when 'id'
            puts "Enter customer id for customer lookup:"
            custData = gets.chomp!
            response = CustomerClient.getById custData
            if response.code == 404
                puts "customer not found!"
            else
                puts "status #{response.code}"
                puts response.body
            end
        
        when 'quit'
            break
    end
end