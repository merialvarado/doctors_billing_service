# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create Admin User
puts "Creating Admin user....."
User.create!(
  email: "admin@billingservice.com",
  user_role: "Administrator", 
  full_name: "Admin", 
  password: "password", 
  password_confirmation: "password", 
  system_generated_password: "password"
  )

# Create Hospital
puts "Creating Hospital....."
hospital = Hospital.create(
  :name => "PSH"
)

puts "Creating Doctor user....."
# Create Doctor User
User.create!(
  email: "doctor@billingservice.com",
  user_role: "Doctor", 
  full_name: "Dr. Amelia Santos", 
  password: "password", 
  password_confirmation: "password", 
  system_generated_password: "password",
  hospital_id: hospital.id
  )

User.create!(
  email: "pdelacruz@billingservice.com",
  user_role: "Doctor", 
  full_name: "P. De la Cruz", 
  password: "password", 
  password_confirmation: "password", 
  system_generated_password: "password",
  hospital_id: hospital.id
  )

# Create Encoder User
puts "Creating Encoder user....."
User.create!(
  email: "encoder@billingservice.com",
  user_role: "Encoder", 
  full_name: "Encoder 1", 
  password: "password", 
  password_confirmation: "password", 
  system_generated_password: "password"
  )