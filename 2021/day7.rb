#!/usr/bin/env ruby

class Day7
  def self.run(input_file)
    puts "Part 1: #{Day7.new(input_file).part_one}"
    puts "Part 2: #{Day7.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    positions = File.open(@filename) do |file|
      file.readlines[0].split(",").map(&:to_i)
    end

    positions.min.upto(positions.max).map do |position|
      positions.inject(0) do |cost, crab|
        cost += (crab - position).abs
      end
    end.min
  end

  def part_two
    positions = File.open(@filename) do |file|
      file.readlines[0].split(",").map(&:to_i)
    end

    positions.min.upto(positions.max).map do |position|
      positions.inject(0) do |cost, crab|
        distance = (crab - position).abs
        cost += distance * (distance + 1) / 2
      end
    end.min
  end
end

Day7.run 'input/day7.txt' if __FILE__ == $0
