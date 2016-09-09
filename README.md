## Can't Stop, Won't Stop

## What

This repo contains programs used for a conference talk on "optimal stopping" AKA the "secretary problem" https://en.wikipedia.org/wiki/Secretary_problem. Shout out to [Algorithms to Live by](https://www.amazon.com/Algorithms-Live-Computer-Science-Decisions/dp/1627790365) for being a very entertaining intro to this algorithm and others.

## Install

All programs in this repo are written in Ruby, you'll need that on your system.

```
$ ruby -v
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin14]
```

You'll also need bundler:

```
$ gem install bundler
```

Then you can install dependencies

```
$ bundle install
```

Now you're ready to run the programs

## Problem statement

Here's the rules:

  - There is a single position to fill.
  - There are n applicants for the position, and the value of n is known.
  - The applicants, if seen altogether, can be ranked from best to worst unambiguously.
  - The applicants are interviewed sequentially in random order, with each order being equally likely.
  - Immediately after an interview, the interviewed applicant is either accepted or rejected, and the decision is revocable.
  - The decision to accept or reject an applicant can be based only on the relative ranks of the applicants terviewed so far.
  - The objective of the general solution is to have the highest probability of selecting the best applicant of the ole group. This is the same as maximizing the expected payoff, with payoff defined to be one for the best applicant d zero otherwise.

This is known as the "secretary problem" https://en.wikipedia.org/wiki/Secretary_problem

If you keep looking you have more informaiton (because you know what came previously), however you have fewer options.
The known solution is to look for a fixed time then look for the next value that is greater than one already seen.

## Organization

There are multiple programs in this repo. Each is related to optimal stopping but each has a different purpose. All programs are in the `lib` directory.

## Experimentally Prove Optimal Stopping

Given that we know the "solution" is to look for a fixed percentage of the time, how can we experimentally determine what percentage of the time should we spend looking? Since computers are pretty fast we can simulate N attempts at finding a candidate using a stopping point from 0 to 100 % and see which one picks the most best candidates.

You can run this program like this:

```
$ ruby lib/computer.rb
Testing each percentage 1000 times
0 %: 41 hits
1 %: 84 hits
2 %: 105 hits
3 %: 133 hits
4 %: 133 hits
5 %: 170 hits
6 %: 219 hits
7 %: 223 hits
8 %: 250 hits
9 %: 263 hits
10 %: 261 hits
11 %: 254 hits
12 %: 282 hits
13 %: 286 hits
14 %: 275 hits
15 %: 309 hits
16 %: 313 hits
17 %: 304 hits
# ...
```


After the computation is done you'll get a prompt to show the relative rankings in which we sort to show which percentages did the best, hit enter to continue:

```
Show rankings>
0: 42 % (401 hits)
1: 43 % (395 hits)
2: 40 % (392 hits)
3: 46 % (391 hits)
4: 34 % (386 hits)
5: 35 % (381 hits)
6: 32 % (379 hits)
7: 41 % (376 hits)
8: 30 % (372 hits)
9: 23 % (368 hits)
10: 47 % (368 hits)
11: 37 % (367 hits)
# ...
```

We can see in this simulation that stopping to look after 42% of the candidates produced the best candidate 401 out of 1000 attempts.

By default it will test N = 1000 simulations. You can pass in a different value if you want

```
$ ruby lib/computer.rb 100_000
Testing each percentage 100000 times
# ...
```

Here's what I don't understand at this time. The provable solution using probability is 37 %. While 37% often does well, (in the top 20) I've not found a large enough value of N for which it will ALWAYS win i.e. come in first. I did one simulation with 1,000,000 simulations, and it still came in 4th place:

```
0: 36 % (371492 hits)
1: 35 % (370938 hits)
2: 33 % (370613 hits)
3: 37 % (370161 hits)
```

So my quesiton is this, why can't I experimentally prove that the mathmatically provable result is correct? If it's true that the probabilities are correct I would expect that given it's statistical advantage that after running enough simulations that 37 could always end up being in the top position.


