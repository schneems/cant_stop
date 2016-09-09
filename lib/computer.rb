# This program is designed to demonstrate the optimal solution for the "secretary problem"
#
# When you run the program the computer will simulate N attempts to find the optimal candidate. It does this using
# a `stop_looking_after_percent` from 0 to 100 %. The theoretical best place to stop looking is at 36.8 % let's
# see if we can experimentally observe the best case scenario.
#
## === PROGRAM ===


# A Recruiter generates candidates
class Recruiter
  def initialize(number_of_candidates)
    @number_of_candidates = number_of_candidates
  end

  def find_candidates
    @number_of_candidates.times.map { rand }
  end
end


# A hiring manager will find the best candidate for the job
# given the rules posted above. They will use the explore/exploit model
# to pick the best candidate. That is they will not hire anyone for a fixed
# percentage of candidates, this is to gather information that is then "exploited"
# to make a choice by hiring the next best candidate. The effectiveness
# of this stragegy depends on the value of "when to stop looking" and start hiring.
class HiringManager
  # `candidates` is an array of candidate scores. The higher the score
  # the better the candidate.
  # `stop_looking_after_percent` is a number less than one that denotes
  # when the hiring manager will stop "exploring" candidates and hire
  # the next best candidate
  def initialize(candidates: , stop_looking_after_percent: 37.0/100)
    @candidates           = candidates
    @best_candidate       = @candidates.max
    @stop_looking_after   = candidates.length * stop_looking_after_percent
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

iterations = Integer(ARGV.first || 1000)

puts "Testing each percentage #{iterations} times"

run_tracker = {}

# Loop through all percentages to calculate how many hits we get from 0 to 100
0..100.times.each do |percentage|

  matches = 0
  iterations.times.each do
    candidates = Recruiter.new(100).find_candidates
    manager    = HiringManager.new(candidates: candidates, stop_looking_after_percent: percentage/100.0)
    manager.select_candidate!
    matches += 1 if manager.picked_best?
  end
  run_tracker[percentage] = matches
  puts "#{ percentage } %: #{ matches } hits"
end

print("Show rankings> ")
gets("\n")
run_tracker.sort_by {|_key, value| value}.reverse.each.with_index do |(k, v), i|
  puts "#{i}: #{k} % (#{v} hits)"
end


