require_relative 'spec_helper'

begin
  User.all.destroy_all
  Card.all.destroy_all
end

describe "GET '/'" do

  it "returns status 200" do
    get '/'
    expect(last_response.status).to eq(200)
  end

end

describe "POST '/signup'" do
  it "returns a status 302" do
    post '/signup', {first_name: "Herine", last_name: "Chin", email: "hchin@gmail.com", password: "dbc"}
    expect(last_response.status).to eq(302)
  end

  it "creates a new user" do
    expect {post '/signup', {first_name: "Joe", last_name: "Chin", email: "joe@gmail.com", password: "dbc"}}.to change{User.count}.by(1)
  end

  it "creates 10 cards" do

    expect {post '/signup', {first_name: "Jazz", last_name: "Chin", email: "jazz@gmail.com", password: "dbc"}}.to change{Card.count}.by(10)
  end

end


describe "GET '/dashboard/:user_id'" do

  it "returns a status 200" do
    @user = User.create(first_name: "Crap", last_name: "Love", email: "love@gmail.com", password: "dbc")
    get "/dashboard/#{@user.id}"
    expect(last_response.status).to eq(200)
  end

  it "contains your card collection" do
    @user = User.create(first_name: "John", last_name: "Joke", email: "cash@gmail.com", password: "dbc")
    @card = @user.cards.create(name: "Storm", description: "This characters bio.")

    @card.accepted = true
    @card.save

    get "/dashboard/#{@user.id}"
    expect(last_response.body).to include("Storm")
  end

end

describe "GET '/new_cards/:user_id'" do
  it "shows all new cards " do
    @user = User.create(first_name: "Law", last_name: "Lee", email: "llp@gmail.com", password: "dbc")
    @user.cards.create(name: "Wolverine", description: "This characters bio.")
    get "/new_cards/#{@user.id}"
    expect(last_response.body).to include("Wolverine")
  end
end

describe "GET '/signout'" do

  it "returns a status 200" do
    get '/signout'
    expect(last_response.status).to eq(200)
  end

  it "returns you to the signin page" do
    get '/signout'
    expect(last_response.body).to include("WELCOME!")
  end

end
