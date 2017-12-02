#!/usr/bin/env ruby

(1..2).each do |day_num|
  puts "*** Day #{day_num} ***"
  require_relative "day#{day_num}"
  Object.const_get("Day#{day_num}").run "input/day#{day_num}.txt"
end
