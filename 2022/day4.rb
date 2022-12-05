#!/usr/bin/env ruby

class Day4
  def self.run(input_file)
    runner = Day4.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true).map do |assignments|
      one, two = assignments.split(',')
      one = Range.new(*one.split('-').map(&:to_i))
      two = Range.new(*two.split('-').map(&:to_i))

      [one, two]
    end
  end

  def part_one
    @input.count do |(one, two)|
      one.cover?(two) || two.cover?(one)
    end
  end

  def part_two
    @input.count do |(one, two)|
      (one.to_a & two.to_a).size > 0
    end
  end
end

if ARGV.empty?
  Day4.run 'input/day4.txt'
else
  Day4.run 'test/day4.txt'
end
