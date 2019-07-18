require 'sinatra'
require 'sinatra/reloader' if development?
require './game'


enable :sessions
set :session_secret, "secret"

get '/' do	
	session.delete(:game)
	erb :index
end

post '/' do
	session[:game] = Game.new
	redirect '/play'
end

get '/play' do

	game = session[:game]

	@turns = game.turns
	@message = game.message
	@board = game.board
	@answer_board = game.answer_board

	erb :play
end

post '/guess' do

	game = session[:game]
	@guess = [params['guess1'].to_i, 
			  params['guess2'].to_i, 
			  params['guess3'].to_i, 
			  params['guess4'].to_i]

	game.update_guess(@guess)
	game.do_turn

	redirect :play
end
