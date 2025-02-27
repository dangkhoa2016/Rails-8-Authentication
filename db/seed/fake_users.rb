require 'csv'

file_path = Rails.root.join('db', 'seed', 'fake_users.csv')
total = 0
max = 20

CSV.foreach(file_path, headers: true) do |row|
  attributes = row.to_hash.transform_keys { |key| key.downcase.tr(' ', '_') }
  puts "Creating user with attributes: #{attributes}"

  user = User.find_or_initialize_by(email: attributes['email'])
  user.assign_attributes(attributes)
  user.password = 'password'
  user.confirmed_at = Time.now
  is_existing_record = user.persisted?
  if user.save
    puts "User #{is_existing_record ? 'updated' : 'created'} with email: #{user.email}"

    total += 1
    break if total >= max
  else
    puts "Failed to create user with email: #{user.email}. Errors: #{user.errors.full_messages}"
  end
end
