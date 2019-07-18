class Game

	attr_accessor :code, :turns, :answer, :guess, :message, :game_won, :board, :answer_board

	def initialize
		@turns = 0
		@code = new_code
		@game_over = false
		@game_won = false
		@answer = []
		@guess = []
		@message = ""
		@board = Array.new(12) { Array.new(4, " ") }
		@answer_board = Array.new(12) { Array.new(4, " ") }
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
		@board[@turns] = @guess
	end

	def check_answer(array)

		answer = []
		missed_guesses = []
		missed_code = []

		array.each_with_index do |num, index|
			if num == @code[index]
				answer << "X"
			else
				missed_guesses << num
				missed_code << @code[index]
			end
		end

		missed_guesses.each do |num|
			if missed_code.include?(num)
				answer << "O"
				missed_code[missed_code.index(num)] = 0
			end
		end
		@answer = answer
		@answer_board[@turns - 1] = @answer
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