# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  user_params = {
    email: 'admin@admin.admin',
    username: 'admin',
    first_name: 'Admin',
    last_name: 'Master',
    role: 'admin'
  }

  user = User.find_by(user_params)
  if user.present?
    puts "Admin user already exists with email: #{user.email}"
    return
  end

  user = User.new(user_params)
  password = 'adminadmin'

  user.password = password
  user.confirmed_at = Time.now
  user.save!

  puts "Admin user created with email: #{user.email} and password: #{password}"
end
