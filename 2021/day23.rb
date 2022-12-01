#!/usr/bin/env ruby

class Day23
  def self.run(input_file)
    runner = Day23.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    @input
  end

  def part_two
  end
end

if ARGV.empty?
  Day23.run 'input/day23.txt'
else
  Day23.run 'test/day23.txt'
end

