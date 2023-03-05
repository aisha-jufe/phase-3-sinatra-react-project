class ApplicationController < Sinatra::Base

  set :default_content_type, 'application/json'

  enable :sessions

# Define a route to get all projects for a user

get '/users' do
users = User.all
users.to_json(include: [:projects, :skills])
  end

get '/users/:id/projects' do
  content_type :json
  user_id = params[:id]
  # Retrieve all projects for the given user from the database
  projects = Project.where(user_id: user_id)
  # Return the projects as JSON
  projects.to_json
end

# create a new user in the database
post '/add/user' do
  # # check if email already exists in database
  # if User.find_by(email: params[:email])
  #   return "Error: Email already exists"
  # end
  # # create a new user
  user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    career: params[:career],
    bio: params[:bio],
    password: params[:password]
  )
  user.save
end

# login
  # Handle login form submission
 post "/login" do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user[:id]
    content_type :json
    { success: true, message: "Login successful" }.to_json
  else
    content_type :json
    status 401 # unauthorized
    { error: "Invalid email or password." }.to_json 
  end
 end

# user's dashboard
get "/user/:email" do
user = User.find_by(email: params[:email])
user.to_json(include: [:projects, :skills])
end

# route for adding new skills
post '/add/skill/:id' do
  # create a new user
  skill = Skill.new(
    name: params[:name],
    description: params[:description],
    user_id: params[:id]
  )
  skill.save
end

# route for updating user skills
put "/skills/:id/:skill_id" do
  user = User.find(params[:id]).skills.find(params[:skill_id])# Find the user by id
  user.update(name: params[:name], description: params[:description]) # Update the user's name and email
end

# route for deleting a skill
delete '/destroy/skills/:id/:skill_id' do
  # Find and delete the skill with the given id here
  user = User.find(params[:id]).skills.find_by(id: params[:skill_id])# Find the user by id
  user.destroy
end

# addign a new project
post '/add/projects/:id' do
  project = Project.create(
    title: params[:title],
    description: params[:description],
    project_Github_url: params[:Github_url],
    user_id: params[:id]
  )
end

# Define a route to update an existing project for a user
put '/users/:id/projects/:project_id' do
  content_type :json
  user_id = params[:id]
  project_id = params[:project_id]
  project = Project.where(user_id: user_id, id: project_id).first
  if project
    # Update the project attributes
    project.update_attributes(params[:project])
    # Return the updated project as JSON
    project.to_json
  else
    # Return an error message as JSON
    { error: 'Project not found' }.to_json
  end
end

# Define a route to delete a project for a user
delete '/users/:id/projects/:project_id' do
  content_type :json
  user_id = params[:id]
  project_id = params[:project_id]
  project = Project.where(user_id: user_id, id: project_id).first
  if project
    # Delete the project from the database
    project.destroy
    # Return a success message as JSON
    { message: 'Project deleted successfully' }.to_json
  else
    # Return an error message as JSON
    { error: 'Project not found' }.to_json
  end
  end

end