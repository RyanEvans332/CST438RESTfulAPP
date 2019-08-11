class Customer < ApplicationRecord
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :email, presence: true
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
    validates :email, uniqueness: true
    

end