json.array!(@users) do |user|
  json.extract! user, :id, 
                      :username,
                      :user_role,
                      :full_name, 
                      :email, 
  json.url user_url(user, format: :json)
end
