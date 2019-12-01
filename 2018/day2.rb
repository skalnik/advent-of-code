#!/usr/bin/env ruby
require 'set'

def distance(a, b)
  a, b = a.downcase, b.downcase
  costs = Array(0..b.length) # i == 0
  (1..a.length).each do |i|
    costs[0], nw = i, i - 1  # j == 0; nw is lev(i-1, j)
    (1..b.length).each do |j|
      costs[j], nw = [costs[j] + 1, costs[j-1] + 1, a[i-1] == b[j-1] ? nw : nw + 1].min, costs[j]
    end
  end
  costs[b.length]
end

class Day2
  def self.run(input_file)
    ids = IO.readlines(input_file, chomp: true)
    total_two = 0
    total_three = 0
    ids.each do |id|
      chars = Set.new(id.chars)
      has_two, has_three = false, false
      chars.each do |char|
        has_two = true if id.count(char) == 2
        has_three = true if id.count(char) == 3
      end

      total_two += 1 if has_two
      total_three += 1 if has_three
    end

    puts "Checksum: #{total_two * total_three}"

    done = false
    ids.each do |id1|
      ids.each do |id2|
        if distance(id1, id2) == 1
          puts "Common letters: #{(id1.chars & id2.chars).join('')}"
          done = true
          break
        end
      end
      break if done
    end
  end
end

Day2.run 'input/day2.txt' if __FILE__ == $0
