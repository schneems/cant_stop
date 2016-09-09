require 'io/console'

require 'artii'

@artii    = Artii::Base.new font: 'colossal'

def select_number(message = "Enter a valid number> ")
  clear
  print(message)
  value = gets("\n")
  if "" == value.strip
    value = 10
  end
  value = Integer(value)
  puts @artii.asciify(value.to_s)
  return value
rescue ArgumentError
  puts "#{value.strip.inspect} is not a valid integer"
end



# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end


def go_stop(message = "Right key for next, space to select> ")
  print(message)
  value = read_char
  case value
  when "\e[C" # right key
    return :go
  when " ", "\n", "\r"
    return :stop
  when "\u0003"
    exit
  else
    puts "Did not understand #{value.inspect}"
    go_stop
  end
end

def clear
  printf "\ec"
end

number_of_candidates = select_number("Enter a number of candidates> ")

largest = rand(number_of_candidates..number_of_candidates*rand(5..100))

candidates = []
selection  = nil

number_of_candidates.times.each do |i|
  candidates << rand(1..largest)
end

previously_seen_candidates = []
candidates.each.with_index do |candidate, i|
  clear
  puts "Choose from #{ i + 1 }/#{ number_of_candidates } candidates"
  puts "Previous candidates: #{ previously_seen_candidates.inspect }"
  puts

  previously_seen_candidates << candidate
  selection = candidate
  puts @artii.asciify(candidate)
  break if :stop == go_stop
end

largest = candidates.max

score = (1.0 * selection / largest * 100.0).floor
if score > 50
  color = 32 # green
else
  color = 31 # red
end

def colorize(color_code, input)
  "\e[#{color_code}m#{input}\e[0m"
end

clear
puts "Candidates: #{candidates.inspect}"
puts "You Selected: #{selection}"
puts "Largest: #{largest}"
puts
puts colorize(color, @artii.asciify("#{ score } %"))
puts

