# When to stop looking

# Here's the rules:
#
#   - There is a single position to fill.
#   - There are n applicants for the position, and the value of n is known.
#   - The applicants, if seen altogether, can be ranked from best to worst unambiguously.
#   - The applicants are interviewed sequentially in random order, with each order being equally likely.
#   - Immediately after an interview, the interviewed applicant is either accepted or rejected, and the decision is irrevocable.
#   - The decision to accept or reject an applicant can be based only on the relative ranks of the applicants interviewed so far.
#   - The objective of the general solution is to have the highest probability of selecting the best applicant of the whole group. This is the same as maximizing the expected payoff, with payoff defined to be one for the best applicant and zero otherwise.
#
# This is known as the "secretary problem" https://en.wikipedia.org/wiki/Secretary_problem
#
# If you keep looking you have more informaiton (because you know what came previously), however you have fewer options.
# The known solution is to look for a fixed time then look for the next value that is greater than one already seen
#
#


class Recruiter
  def initialize(number_of_candidates: , stop_looking_after_percent: 37.0/100)
    @number_of_candidates = number_of_candidates
    @candidates           = number_of_candidates.times.map { rand }
    @best_candidate       = @candidates.max
    @stop_looking_after   = number_of_candidates * stop_looking_after_percent
  end

  def select_candidate!
    best_so_far = 0
    @candidates.each.with_index do |candidate, index|
      if index > @stop_looking_after
        @selected = candidate if candidate > best_so_far
      else
        best_so_far = candidate if candidate > best_so_far
      end
    end
    @selected ||= @candidates.last
  end

  def picked_best?
    @selected || select_candidate!
    @selected == @best_candidate
  end
end

## Run things

run_tracker = {}

# Loop through all percentages to calculate how many hits we get from 0 to 100
0..100.times.each do |percentage|

  matches = 0
  1000.times.each do
    recruiter = Recruiter.new(number_of_candidates: 100, stop_looking_after_percent: percentage/100.0)
    recruiter.select_candidate!
    matches += 1 if recruiter.picked_best?
  end
  run_tracker[percentage] = matches
  puts "#{ percentage } %: #{ matches } hits"
end

print("Show rankings> ")
gets("\n")
run_tracker.sort_by {|_key, value| value}.reverse.each.with_index do |(k, v), i|
  puts "#{i}: #{k} % (#{v} hits)"
end


