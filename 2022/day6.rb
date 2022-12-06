#!/usr/bin/env ruby

class Day6
  def self.run(input_file)
    runner = Day6.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)[0]
  end

  def part_one
    @input.chars.each_cons(4).each_with_index do |set, index|
      return index + 4 if set.uniq.size == set.size
    end
  end

  def part_two
    @input.chars.each_cons(14).each_with_index do |set, index|
      return index + 14 if set.uniq.size == set.size
    end
  end
end

if ARGV.empty?
  Day6.run 'input/day6.txt'
else
  Day6.run 'test/day6.txt'
end
