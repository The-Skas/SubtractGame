
$DEBUG = false

def main
	if(ARGV.length < 4)
		puts "*Invalid Arguements*"
		puts "Format: ruby remove_match_game.rb [start_number] [[operator]val1] [[operator]val2] [[operator]val3] [isPlayerOne=optional]"
		puts ""
		puts "       start_number: The number that represents the starting position"
		puts "       val1        : A number that either divides(/), subtracts(-), (*)multiplies the start_number"
		puts "       val2        : A number that either divides(/), subtracts(-), (*)multiplies the start_number"
		puts "       val3        : A number that either divides(/), subtracts(-), (*)multiplies the start_number"
		puts "       operator    : an operator, representing wether to -(subtract) , +(add)  ,/(divide)"
		puts "       isPlayerOne : A boolean representing if playerOne starts the first move"
		puts ""
		puts "       Example: > ruby remove_match_game.rb 10 -2 -3 /2 true"
		puts "       Output:  > X(10) - 1"		
	else

		if(ARGV[4].nil?)
			ARGV[4] = true
		else
			if(ARGV[4] == "false")
				ARGV[4] = false;
			else
				ARGV[4] = true;
			end
		end

		subtract_game(ARGV[0], ARGV[1], ARGV[2], ARGV[3], ARGV[4])
	end
end

def subtract_game(start_number,val1 = 2,val2=3,val3=5, playerOne=true)
	does_win = recursive_who_wins(start_number, playerOne, val1, val2, val3)
	puts " X(#{start_number}) - #{(does_win ? 1 : 0)}"
end



=begin
	This method's complexity is O(n^3) or n cubed.

	if the number chosen is above 53. It takes ages to compute. :[]
=end
def recursive_who_wins(number, isPlayerOne,val1, val2, val3)

	if(number.to_i <= 0)
		# We get the opposite since value of isPlayerOne 
		if($DEBUG)
			puts rec_p(1)+"P1: #{isPlayerOne}"
			puts rec_p(1)+"return: #{!isPlayerOne}"
		end
		return (!isPlayerOne)
	end
	# binding.pry
	if($DEBUG)
		puts rec_p(1)+"P1: #{isPlayerOne}"
		puts rec_p(1)+"number: #{number}"
	end

	# The first if statement represents the choice of player 1.
	# If any one of the subtrees is true, then that means
	# player one has a guaranteed winning move.
	# 
	# The else represents player 2. Such that player 2 will always
	# choose the move that makes player 1 lose (and player 2 wins)
	# So it only evaluates to player one winning true, if ALL subtrees are true.
	
	any_wins = false

	if(isPlayerOne)
		if(possibleToCalc(number,val1))
			any_wins = any_wins || recursive_who_wins(calculate(number,val1), !isPlayerOne, val1,val2,val3)
		end
		if(possibleToCalc(number,val2))
			any_wins = any_wins || recursive_who_wins(calculate(number,val2), !isPlayerOne, val1,val2,val3)
		end
		if(possibleToCalc(number,val3))
			any_wins = any_wins || recursive_who_wins(calculate(number,val3), !isPlayerOne, val1,val2,val3)
		end
		
	else
		# Extremely weird ruby bug when using recursion.
		# any_wins &&= recurriveFunction WILL NOT EXECUTE THE RECURSION!!
		any_wins = true
		result = any_wins

		if(possibleToCalc(number,val1))
			result = recursive_who_wins(calculate(number,val1), !isPlayerOne, val1,val2,val3)
			any_wins = result
		end
		
		if(possibleToCalc(number, val2))
			result = recursive_who_wins(calculate(number,val2), !isPlayerOne, val1,val2,val3)
			any_wins = any_wins && result
		end
		
		if(possibleToCalc(number, val3))
			result = recursive_who_wins(calculate(number,val3), !isPlayerOne, val1,val2,val3)
			any_wins = any_wins && result
		end

	end

	if($DEBUG)
		puts rec_p(1)+"P1 WIN: #{any_wins}"
		puts rec_p(1)+"-------------------"
	end

	return any_wins
end

# 			a = main_number
# 			b = value
# 			 ex b = '-2'
# 			 		'%2'
# 			 		'*2'
def calculate(a, b)
	operator = b[0]
	a = a.to_i
	b = b[1..-1].to_i

	if(operator == "/")
		return a / b
	elsif (operator == "-")
		return a - b
	elsif (operator == "+")
		return a + b
	elsif(operator == "*")
		return a * b
	end	
end

def possibleToCalc(a, b)

	# Gets the operator from the string
	operator = b[0]
	
	unless ["/","*","+","-"].include?(operator)
		raise "Invalid operator symbol! -> #{b}"
	end

	# Converts num to int
	a = a.to_i

	# Gets the string without the operator, converts it to an int.
	b = b[1..-1].to_i

	# Should not be able to compute.
	if(b == 0 && ["-","/","+"].include?(operator))
		return false
	end


	if(operator == "/")
		return a % b == 0
	end

	return true
end

def recursive_print(arg, minus=20)
		return("     "*(caller(arg).length - 5))
	
end

def rec_p(arg=1, minus = 2)
	return recursive_print(arg, minus)
end



main