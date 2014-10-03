get '/' do
  erb :signin
end

post '/signup' do
  @user = User.create(params)
  session[:user_id] = @user.id
  series = ["X-Men", "Captain%20America", "Fantastic%20Four", "Avengers", "Spider-Man"].sample
  ts = Time.now.to_i
  privkey = "HIDDEN SOMEWHERE FAR FAR AWAY"
  apikey = "89372b9c8a1aa247960d6111b3ea929d"
  digest_this = "#{ts}#{privkey}#{apikey}"
  hash = Digest::MD5.hexdigest(digest_this)

  @marvel_response = HTTParty.get("http://gateway.marvel.com:80/v1/public/characters?series=2265%2C%20403%2C%209906%2C%2017635%2C1996%2C%20832%2C354%2C2069&limit=100&ts=#{ts}&apikey=#{apikey}&hash=#{hash}" )

  @data = @marvel_response["data"]["results"]

  while @user.cards.count < 10
    i = rand(100)
    unless @data[i]["thumbnail"].nil?
      unless @data[i]["thumbnail"]["path"].include?("image_not_available")

        @name = @data[i]["name"]
        @description = @data[i]["description"]
        @image = @data[i]["thumbnail"]["path"] + ".jpg"
        @char_id = @data[i]["id"]

        @user.cards.create( name: @name, description: @description, image: @image, char_id: @char_id )
      end
    end
  end

  redirect "/dashboard/#{@user.id}"
end

post '/signin' do
  @user = User.find_by_email(params[:email])
  if params[:password] == @user.password
    session[:user_id] = @user.id
    redirect "/dashboard/#{@user.id}"
  else
    redirect '/'
  end
end

get '/dashboard/:user_id' do

  @user = User.find(params[:user_id])

  if session[:user_id] == params[:user_id].to_i
    @cards = Card.where(user_id: params[:user_id], accepted: true)
    @new_cards = Card.where(user_id: params[:user_id], accepted: false)
  else
    @error_message = "Sneaky Sneaky, me no likey."
  end
  p "TESTS card"
  p @cards
  p "TESTS new_cards"
  p @new_cards
  erb :dashboard

end

get '/signout' do
  session.clear
  erb :signin
end

get '/accept/:card_id' do
  @card = Card.find(params[:card_id])
  @card.accepted = true
  @card.save
end

get '/delete/:card_id' do
  Card.find(params[:card_id]).delete
end

post '/send/:card_id' do
  p params
  @card = Card.find(params[:card_id])
  @new_user = User.find_by_email(params[:email])
  @card.user_id = @new_user.id
  @card.accepted = false
  @card.save
end


# STRETCH STUFF?????

# get '/profile/:user_id' do
#   @user = User.find(session[:user_id])
#   erb :profile
# end
#
# authenication? email uniqueness
# ways to add new cards (flashcard?s)