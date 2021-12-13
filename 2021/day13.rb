#!/usr/bin/env ruby

require 'set'

class Day13
  def self.run(input_file)
    puts "Part 1: #{Day13.new(input_file).part_one}"
    puts "Part 2: "
    Day13.new(input_file).part_two
  end

  def initialize(filename)
    input = File.open(filename) do |file|
      file.readlines(chomp: true)
    end

    empty = input.find_index("")
    @marked_points = input[0..(empty - 1)]
    @folds = input[(empty + 1)..-1]

    @marked_points.map! do |string|
      string.split(",").map(&:to_i)
    end

    @folds.map! do |fold|
      if /fold along (x|y)=(\d+)/ =~ fold
        { direction: $1.intern, amount: $2.to_i }
      end
    end
  end

  def part_one
    @marked_points.map { |point| fold_point(point[0], point[1], @folds[0][:direction], @folds[0][:amount])}.uniq.size
  end

  def part_two
    points = @marked_points.dup
    @folds.each do |fold|
      points.map! { |p| fold_point(p[0], p[1], fold[:direction], fold[:amount]) }.uniq!
    end

    points.map!(&:reverse)

    max_x = points.map { |p| p[0] }.max
    max_y = points.map { |p| p[1] }.max
    (0..max_x).each do |x|
      (0..max_y).each do |y|
        if points.include? [x, y]
          print "#"
        else
          print " "
        end
      end

      puts
    end
  end
end

def fold_point(x, y, direction, amount)
  if direction == :x && x > amount
    [2 * amount - x, y]
  elsif direction == :y && y > amount
    [x, 2 * amount - y]
  else
    [x, y]
  end
end

if ARGV.empty?
  Day13.run 'input/day13.txt'
else
  Day13.run 'test/day13.txt'
end
