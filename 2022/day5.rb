#!/usr/bin/env ruby

class Day5
  def self.run(input_file)
    runner = Day5.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    stacks = parse_stacks
    seperator = @input.find_index('') + 1
    @input[seperator..@input.length].each do |instruction|
      (num, source, dest) = /move (\d+) from (\d+) to (\d+)/.match(instruction).to_a.slice(1..3).map(&:to_i)

      crates = stacks[source - 1].pop(num)
      stacks[dest - 1].push(*crates.reverse)
    end

    stacks.map(&:last).join
  end

  def part_two
    stacks = parse_stacks
    seperator = @input.find_index('') + 1
    @input[seperator..@input.length].each do |instruction|
      (num, source, dest) = /move (\d+) from (\d+) to (\d+)/.match(instruction).to_a.slice(1..3).map(&:to_i)

      crates = stacks[source - 1].pop(num)
      stacks[dest - 1].push(*crates)
    end

    stacks.map(&:last).join
  end

  def parse_stacks
    seperator = @input.find_index('') - 1
    stack_count = @input[seperator].split(' ').last.to_i
    stacks = Array.new(stack_count) { [] }
    @input[0...seperator].each do |line|
      line.chars.each_slice(4).with_index do |(_, crate, _, _), i|
        stacks[i] << crate if crate != ' '
      end
    end

    stacks.map(&:reverse)
  end
end

if ARGV.empty?
  Day5.run 'input/day5.txt'
else
  Day5.run 'test/day5.txt'
end
