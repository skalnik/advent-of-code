#!/usr/bin/env ruby

class Day3
  def self.run(input_file)
    runner = Day3.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    sum = 0
    arr = @input.map { |x| x.split('') }
    p arr
    neighbors = [
      [-1, -1], [-1, 0], [-1, 1],
      [ 0, -1],          [ 0, 1],
      [ 1, -1], [ 1, 0], [ 1, 1]]
    @input.each_with_index do |line, x|
      line.enum_for(:scan, /(\d+)/).each do |num|
        adjacent = false
        first = Regexp.last_match.begin(0)
        last = Regexp.last_match.end(0) - 1
        (first..last).each do |y|
          break if adjacent
          neighbors.each do |n|
            next if x + n[0] < 0 || y + n[1] < 0 || arr[x+n[0]].nil? || x + n[0] > arr.length || y + n[1] > arr[x+n[0]].length
            val = arr[x + n[0]][y + n[1]]
            if !val.nil? && val != "." && val !~ /\d/
              puts "#{num[0]} is adjacent to #{val} at #{x + n[0]}, #{y + n[1]}"
              adjacent = true
              sum += num[0].to_i
              break
            end
          end
        end
      end
    end

    sum
  end

  def part_two
  end
end

if ARGV.empty?
  Day3.run 'input/day2.txt'
else
  Day3.run ARGV.first
end

# Part 1
# 551623 too high
# 12225 too low
