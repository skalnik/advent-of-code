#!/usr/bin/env ruby

class Day8
  def self.run(input_file)
    puts "Part 1: #{Day8.new(input_file).part_one}"
    puts "Part 2: #{Day8.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    total = 0
    File.open(@filename) do |file|
      file.each_line(chomp: true) do |line|
        patterns, output_value = line.split(" | ").map { |s| s.split(" ") }
        total += output_value.map(&:length).select { |x| [2, 4, 3, 7].include? x }.length
      end
    end
    total
  end

  def part_two
    sum = 0
    File.open(@filename) do |file|
      file.each_line(chomp: true) do |line|
        patterns, output_values = line.split(" | ").map { |s| s.split(" ") }

        patterns.map! { |v| v.chars.sort.join("") }
        output_values.map! { |v| v.chars.sort.join("") }

        segments = [
          "abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"
        ].map(&:chars)

        test_cases = (patterns + output_values).map(&:chars)

        solutions = []
        solutions[1] = test_cases.detect { |x| x.length == segments[1].length }
        solutions[4] = test_cases.detect { |x| x.length == segments[4].length }
        solutions[7] = test_cases.detect { |x| x.length == segments[7].length }
        solutions[8] = test_cases.detect { |x| x.length == segments[8].length }

        solutions[0] = test_cases.detect do |x|
          x.length == segments[0].length && 
            (x & solutions[1]).length == 2 &&
            (x & solutions[4]).length == 3 &&
            (x & solutions[7]).length == 3 &&
            (x & solutions[8]).length == 6
        end

        solutions[2] = test_cases.detect do |x|
          x.length == segments[2].length && 
            (x & solutions[1]).length == 1 &&
            (x & solutions[4]).length == 2 &&
            (x & solutions[7]).length == 2 &&
            (x & solutions[8]).length == 5
        end

        solutions[3] = test_cases.detect do |x|
          x.length == segments[3].length &&
            (x & solutions[1]).length == 2 &&
            (x & solutions[4]).length == 3 &&
            (x & solutions[7]).length == 3 &&
            (x & solutions[8]).length == 5
        end

        solutions[5] = test_cases.detect do |x|
          x.length == segments[5].length && 
            (x & solutions[1]).length == 1 &&
            (x & solutions[4]).length == 3 &&
            (x & solutions[7]).length == 2 &&
            (x & solutions[8]).length == 5
        end

        solutions[6] = test_cases.detect do |x|
          x.length == segments[6].length && 
            (x & solutions[1]).length == 1 &&
            (x & solutions[4]).length == 3 &&
            (x & solutions[7]).length == 2 &&
            (x & solutions[8]).length == 6
        end

        solutions[9] = test_cases.detect do |x|
          x.length == segments[9].length && 
            (x & solutions[1]).length == 2 &&
            (x & solutions[4]).length == 4 &&
            (x & solutions[7]).length == 3 &&
            (x & solutions[8]).length == 6
        end

        solutions.map! { |v| v && v.join("") }

        output = output_values.map { |v| solutions.index(v) }
        sum += output.compact.join("").to_i
      end
    end
    sum
  end
end

if ARGV.empty?
  Day8.run 'input/day8.txt'
else
  Day8.run 'test/day8.txt'
end
