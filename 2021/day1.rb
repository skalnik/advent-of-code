#!/usr/bin/env ruby

class Day1
  def self.run(input_file)
    puts "Part 1: #{Day1.new(input_file).part_one}"
    puts "Part 2: #{Day1.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    depths = nil
    File.open(@filename) do |file|
      depths = file.readlines.map { |x| Integer(x) }
    end

    increases(depths)
  end

  def part_two
    depths = nil
    File.open(@filename) do |file|
      a = file.readlines.map { |x| Integer(x) }
      b = a.dup
      c = a.dup

      a.pop
      a.pop

      b.shift
      b.pop

      c.shift
      c.shift

      depths = [a, b, c].transpose.map(&:sum)
    end

    increases(depths)
  end

  def increases(depths)
    total = 0
    previous_depth = depths.shift
    depths.each do |depth|
      total += 1 if depth > previous_depth
      previous_depth = depth
    end

    total
  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
