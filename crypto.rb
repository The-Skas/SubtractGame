require 'prime'
require 'pry'
require_relative 'text_vars.rb'
=begin
	This Short script does a simple inefficient RSA encryption/decryption.
=end

$title = "╦ ╦┌─┐┬  ┌─┐  ╔═╗┌─┐┌─┐┌─┐┌┬┐   ╔═╗┬─┐┬ ┬┌─┐┌┬┐┌─┐
╠═╣├─┤│  ├┤───╠═╣└─┐└─┐├┤  ││───║  ├┬┘└┬┘├─┘ │ │ │
╩ ╩┴ ┴┴─┘└    ╩ ╩└─┘└─┘└─┘─┴┘   ╚═╝┴└─ ┴ ┴   ┴ └─┘"
                                                                                                                                     

def main()
	prime_numbers = Prime.first 10000
	random_index = Random.rand(prime_numbers.length)
	prime_numbers_ex =  prime_numbers[random_index, 10]

	if(ARGV.length < 3)
		puts ""
		puts "*Invalid Arguements*"
		puts "This script generates an RSA public key, private key. "
		puts "It is by no means efficient. This is only to be used for small numbers."
		puts ""
		puts "Format: ruby crypto.rb [prime_num_p] [prime_num_q] [e_pub]"
		puts "        prime_num_p: (p) A prime Number"
		puts "        prime_num_q: (q) Another prime Number"
		puts "        e_pub      : (b) Public Key Exponent"
		puts ""
		puts "        example prime numbers: #{prime_numbers_ex}"
		return
	end
	
	if(Prime.prime?(ARGV[0].to_i) == false || Prime.prime?(ARGV[1].to_i) == false)
		puts "Invalid Number!"
		puts "Not a valid Prime Number"
		puts "example prime numbers: #{prime_numbers_ex}"
		return
	end


	crypto(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
end


def is_epub_invalid(e_pub,totient)
	invalid = e_pub == 0
	invalid = invalid || (e_pub <= 1 && e_pub >= totient)
	invalid = invalid || (e_pub.gcd(totient) != 1)

	return invalid
end

def crypto(prime_p, prime_q, e_pub)
	n = prime_p * prime_q
	#http://en.wikipedia.org/wiki/Euler%27s_totient_function#Totient_numbers
	totient = (prime_p - 1) * (prime_q - 1)

	if(is_epub_invalid(e_pub, totient))
		raise "INVALID e_pub (b) value!"
		puts "Generating a valid e_pub value..."
		
		until(e_pub.gcd(totient) == 1)
			e_pub = (Random.rand()*totient).to_i
		end

	end
	# Modular multiplative Inverse
	# http://en.wikipedia.org/wiki/Modular_multiplicative_inverse\
	e_priv = 0

	# Find a number where, d is the multiplacitive inverse
	i = 0
	while(e_priv == 0)
		i = i + 1
		if(((i*e_pub) % totient == 1) && i != e_pub)
			# Found it!
			e_priv = i
		end
	end
	puts ""
	puts "#{$title}"
	puts ""
	puts ""
	puts "given: prime_p: #{prime_p}, prime_q: #{prime_q}, and e_pub: #{e_pub}"
	puts "e_priv is: #{e_priv}"

	puts ""

	puts "public key  is: (#{e_pub}, #{n}) - public key(e_pub, n)"
	puts "private key is: (#{e_priv}, #{n})- public key(e_priv, n)"

end

main()



