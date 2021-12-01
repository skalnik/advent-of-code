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
    increases = 0
    File.open(@filename) do |file|
      previous_depth = nil
      file.each_line do |depth|
        depth = Integer(depth)
        if previous_depth
          if depth > previous_depth
            increases += 1
          end
        end
        previous_depth = depth
      end
    end

    increases
  end

  def part_two
    increases = 0
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

      groups = [a, b, c].transpose.map(&:sum)

      previous_depth = nil
      groups.each do |depth|
        if previous_depth
          if depth > previous_depth
            increases += 1
          end
        end
        previous_depth = depth
      end
    end

    increases

  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
