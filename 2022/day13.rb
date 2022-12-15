#!/usr/bin/env ruby

class Day13
  def self.run(input_file)
    runner = Day13.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    sum = 0
    @input.each_slice(3).each_with_index do |(left, right, _), index|
      index += 1
      left = eval left
      right = eval right
      sum += index if compare_value(left, right).positive?
    end

    sum
  end

  def part_two
    packets = [
      [[2]],
      [[6]]
    ]
    @input.each_slice(3) do |(left, right, _)|
      packets << eval(left)
      packets << eval(right)
    end

    packets.sort! { |a, b| compare_value(b, a) }

    two = packets.find_index([[2]]) + 1
    six = packets.find_index([[6]]) + 1

    two * six
  end

  def compare_value(left, right, debug: false)
    left = left.dup
    right = right.dup
    puts "Comparing #{left.inspect} vs #{right.inspect}" if debug
    if left.is_a?(Array) && right.is_a?(Array)
      return -1 if right.empty? && !left.empty?
      return 0 if right.empty? && left.empty?

      first_comp = compare_value(left.shift, right.shift)

      return compare_value(left, right) if first_comp.zero?

      return first_comp
    end

    return 1 if left.nil?

    if left.is_a?(Numeric) && right.is_a?(Array)
      puts "Mixed types; convert left to #{[left].inspect} and retry" if debug
      return compare_value([left], right)
    elsif left.is_a?(Array) && right.is_a?(Numeric)
      puts "Mixed types; convert right to #{[right].inspect} and retry" if debug
      return compare_value(left, [right])
    end

    compare = right <=> left
    if debug
      if compare.positive?
        puts 'Right order'
      elsif compare.negative?
        puts 'Wrong order'
      end
    end

    compare
  end
end

if ARGV.empty?
  Day13.run 'input/day13.txt'
else
  Day13.run 'test/day13.txt'
end
