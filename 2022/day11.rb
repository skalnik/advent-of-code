#!/usr/bin/env ruby
require 'bigdecimal'

class Day11
  def self.run(input_file)
    runner = Day11.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    monkeys = build_monkeys(@input)
    20.times do
      monkeys.each do |monkey|
        throwing = monkey.inspect_items
        throwing.each_pair do |number, items|
          monkeys[number].items.append(*items)
        end
      end
    end

    monkeys.max(2) { |a, b| a.inspections <=> b.inspections }.map(&:inspections).inject(1, &:*)
  end

  def part_two
    monkeys = build_monkeys(@input)

    mod = monkeys.inject(1) do |product, monkey|
      product * monkey.test
    end
    10_000.times do
      monkeys.each do |monkey|
        throwing = monkey.inspect_items(false, mod: mod)
        throwing.each_pair do |number, items|
          monkeys[number].items.append(*items)
        end
      end
    end

    monkeys.max(2) { |a, b| a.inspections <=> b.inspections }.map(&:inspections).inject(1, &:*)
  end

  def build_monkeys(input)
    input.each_slice(7).map do |description|
      description.shift
      items = /Starting items: (.+)/.match(description.shift)[1]
      items = items.split(', ').map(&:to_i)
      operation = /Operation: new = (.+)/.match(description.shift)[1]
      test = /Test: divisible by (\d+)/.match(description.shift)[1].to_i
      throw_to = {
        true: /If true: throw to monkey (\d+)/.match(description.shift)[1].to_i,
        false: /If false: throw to monkey (\d+)/.match(description.shift)[1].to_i
      }

      Monkey.new(items: items, operation: operation, test: test, throw_to: throw_to)
    end
  end
end

class Monkey
  attr_reader :operation, :test, :throw_to, :inspections
  attr_accessor :items

  def initialize(items:, operation:, test:, throw_to:)
    @items = items
    @operation = operation
    @test = test
    @throw_to = throw_to
    @inspections = 0
  end

  def inspect_items(divide = true, mod: false, debug: false)
    throwing = Hash.new { |h, k| h[k] = [] }
    @items.each do |item|
      puts "  Monkey inspects an item with worry level #{item}" if debug
      @inspections += 1
      exec_str = @operation.gsub('old', item.to_s)
      new = eval exec_str
      new %= mod if mod # Keep it managable
      puts "    Worry level is #{@operation} to #{new}" if debug
      new = (new.to_f / 3.0).floor if divide
      puts "    Monkey gets bored with item. Worry level is divided by 3 to #{new}" if debug && divide
      if new % @test == 0
        puts "    Current worry level is divisible by #{@test}" if debug
        puts "    Item with worry level #{new} is thrown to monkey #{@throw_to[:true]}" if debug
        throwing[@throw_to[:true]] << new
      else
        puts "    Current worry level is not divisible by #{@test}" if debug
        puts "    Item with worry level #{new} is thrown to monkey #{@throw_to[:false]}" if debug
        throwing[@throw_to[:false]] << new
      end
    end

    @items = []

    throwing
  end

  def to_s
    <<~MONKEY
    Items: #{@items.join(', ')}
    Operation: #{@operation}
    Test: divisible by #{@test}
      If true: throw to monkey #{throw[:true]}
      if false: throw to monkey #{throw[:false]}
    MONKEY
  end
end

if ARGV.empty?
  Day11.run 'input/day11.txt'
else
  Day11.run 'test/day11.txt'
end
