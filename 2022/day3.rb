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
    overlap = []
    @input.each do |rucksack|
      half = (rucksack.length.to_f / 2).ceil
      one = rucksack[0, half]
      two = rucksack[half, rucksack.length]

      overlap << (one.chars & two.chars)
    end

    overlap.flatten.map { |c| score_value(c) }.sum
  end

  def part_two
    overlap = []
    @input.each_slice(3) do |slice|
      overlap << (slice[0].chars & slice[1].chars & slice[2].chars)
    end
    overlap.flatten.map { |c| score_value(c) }.sum
  end

  def score_value(char)
    if char =~ /[A-Z]/
      char.ord - 38
    else
      char.ord - 96
    end
  end
end

if ARGV.empty?
  Day3.run 'input/day3.txt'
else
  Day3.run 'test/day3.txt'
end
