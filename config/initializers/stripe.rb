# filepath: /home/mic/code/Mikke777/ecomm/config/initializers/stripe.rb
require 'stripe'
Stripe.api_key = ENV['STRIPE_SECRET_KEY']
