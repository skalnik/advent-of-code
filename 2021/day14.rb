#!/usr/bin/env ruby

class Day14
  def self.run(input_file)
    runner = Day14.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.open(filename) do |file|
      file.readlines(chomp: true)
    end

    @template = input.shift
    input.shift
    @rules = input.inject({}) do |r, line|
      parts = line.split(" -> ")
      r[parts[0]] = parts[1]
      r
    end
  end

  def part_one
    polymer = @template.dup
    10.times do
      polymer = run_polymerizer(polymer)
    end

    occurances = polymer.chars.tally
    occurances.values.max - occurances.values.min
  end

  def part_two
    counts = Hash.new(0)
    @template.chars.each_cons(2) { |pair| counts[pair.join("")] += 1 }

    40.times do
      counts = run_counting_polymerizer(counts)
    end

    tally = counts.inject(Hash.new(0)) do |t, (pair, count)|
      t[pair[0]] += count
      t
    end
    tally[@template.chars.last] += 1

    tally.values.max - tally.values.min
  end

  def run_polymerizer(polymer)
    new_template = ""
    polymer.chars.each_cons(2) do |con|
      new_template << con[0]
      if rule = @rules[con.join("")]
        new_template << rule
      end
    end
    new_template << polymer.chars.last

    new_template
  end

  def run_counting_polymerizer(pairs)
    pairs.inject(Hash.new(0)) do |new_pairs, (pair, count)|
      if rule = @rules[pair]
        new_pairs[pair[0] + rule] += count
        new_pairs[rule + pair[1]] += count
      else
        new_pairs[pair] += count
      end

      new_pairs
    end
  end
end

if ARGV.empty?
  Day14.run 'input/day14.txt'
else
  Day14.run 'test/day14.txt'
end
