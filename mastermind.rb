require 'sinatra'
require 'sinatra/reloader' if development?



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

	@code = game.code
	@turns = game.turns
	@guess = game.guess
	@answer = game.answer
	@message = game.message
	@game_won = game.game_won

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


class Game

	attr_accessor :code, :turns, :answer, :guess, :message, :game_won

	def initialize
		@turns = 0
		@code = new_code
		@game_over = false
		@game_won = false
		@answer = []
		@guess = []
		@message = ""
	end

	def update_turns
		@turns += 1
		if @turns > 12
			@game_over = true
		end
	end

	def do_turn

		update_turns

		if @game_over == true
			@message = "The game is over. Start a new game to play again"
		elsif @game_won == true
			@message = "Game won"
		else
			check_answer(@guess)
			check_win
			if @game_won == true
				@message = "You won! The correct answer is #{@code}"
			elsif @turns == 12
				@message = "You lost! The correct answer was #{@code}"
			end
		end
	end

	def update_guess(array)
		@guess = array
	end

	def check_answer(array)

		answer = []
		missed_guesses = []
		missed_code = []

		array.each_with_index do |num, index|
			if num == @code[index]
				answer << 2
			else
				missed_guesses << num
				missed_code << @code[index]
			end
		end

		missed_guesses.each do |num|
			if missed_code.include?(num)
				answer << 1
				missed_code[missed_code.index(num)] = 0
			end
		end
		@answer = answer
	end

	def check_win
		if @guess == @code
			@game_won = true 
			@game_over = true
		end
	end

	def new_code
		[random, random, random, random]		
	end

	def random
		rand(6) + 1
	end

end


=begin

	def hash_to_array(hash)
		array = []
		hash.each { |key, value| array << value }
		array
	end
=end