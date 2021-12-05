#!/usr/bin/env ruby

class Day5
  def self.run(input_file)
    puts "Part 1: #{Day5.new(input_file).part_one}"
    puts "Part 2: #{Day5.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    board = Board.new
    File.open(@filename) do |file|
      file.each_line do |line|
        a, b = *line.split(" -> ")
        a = {x: a.split(",")[0].to_i, y: a.split(",")[1].to_i}
        b = {x: b.split(",")[0].to_i, y: b.split(",")[1].to_i}
        current_line = Line.new(a, b)
        board.add_line(current_line) if current_line.straight?
      end
    end

    board.points_over_one
  end

  def part_two
    board = Board.new
    File.open(@filename) do |file|
      file.each_line do |line|
        a, b = *line.split(" -> ")
        a = {x: a.split(",")[0].to_i, y: a.split(",")[1].to_i}
        b = {x: b.split(",")[0].to_i, y: b.split(",")[1].to_i}
        current_line = Line.new(a, b)
        board.add_line(current_line)
      end
    end

    board.points_over_one
  end
end

class Board
  attr_reader :points

  def initialize
    @points = Hash.new { |h, k| h[k] = 0 }
  end

  def add_line(line)
    dx = line.b[:x] <=> line.a[:x]
    dy = line.b[:y] <=> line.a[:y]

    x, y = line.a[:x], line.a[:y]

    loop do
      @points[{x: x, y: y}] += 1
      break if x == line.b[:x] && y == line.b[:y]

      x += dx
      y += dy
    end
  end

  def points_over_one
    @points.values.count { |v| v > 1 }
  end

  def inspect
    @points.inspect
  end
end

class Line
  attr_reader :a, :b
  def initialize(a, b)
    @a, @b = a, b
  end

  def horizontal?
    a[:x] == b[:x]
  end

  def vertical?
    a[:y] == b[:y]
  end

  def straight?
    horizontal? || vertical?
  end

  def inspect
    "#{a.inspect} -> #{b.inspect}"
  end
end

Day5.run 'input/day5.txt' if __FILE__ == $0
