#!/usr/bin/env ruby

class Day17
  def self.run(input_file)
    runner = Day17.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)[0]
    @target = {}
    if input =~ /x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/
      @target[:x] = $1.to_i..$2.to_i
      @target[:y] = $3.to_i..$4.to_i
    end

    @hits = []
    (-200..@target[:x].max).each do |dx|
      (@target[:y].min..200).each do |dy|
        results = simulate(dx, dy)
        @hits << results if results
      end
    end
    @hits.compact!
  end

  def part_one
    @hits.max
  end

  def part_two
    @hits.count
  end

  def simulate(dx, dy)
    x, y, max_y = 0, 0, 0

    loop do
      x += dx
      y += dy

      if dx > 0
        dx -= 1
      elsif dx < 0
        dx += 1
      end

      dy -= 1

      max_y = y if y > max_y

      return nil if y < @target[:y].min || x > @target[:x].max
      return max_y if @target[:x].include?(x) && @target[:y].include?(y)
    end
  end
end

if ARGV.empty?
  Day17.run 'input/day17.txt'
else
  Day17.run 'test/day17.txt'
end
