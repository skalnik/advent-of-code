#!/usr/bin/env ruby
require 'set'

class Day15
  def self.run(input_file)
    runner = Day15.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    grid = Grid.new(@input)
    grid.find_path
  end

  def part_two
    wider = []
    larger_grid = []
    @input.each do |line|
      vals = line.chars.map(&:to_i)
      new_line = []
      (0..4).each do |i|
        new_line << vals.map { |x| increment(x, i) }
      end
      wider << new_line.flatten
    end

    (0..4).each do |i|
      wider.each do |line|
        larger_grid << line.map { |x| increment(x, i) }.join("")
      end
    end

    grid = Grid.new(larger_grid)
    grid.find_path
  end

  def increment(risk, amount)
    n = risk + amount
    if n > 9
      n - 9
    else
      n
    end
  end
end

class Grid
  attr_reader :grid

  def initialize(lines)
    @grid = lines.map do |line|
      line.chars.map(&:to_i)
    end
  end

  def neighbors(x, y)
    neighbors = [[1, 0], [0, 1], [-1, 0], [0, -1]]

    neighbors.map do |(dx, dy)|
      new_x, new_y = x + dx, y + dy
      next if new_x < 0 || new_x >= @grid.size
      next if new_y < 0 || new_y >= @grid[0].size

      [new_x, new_y]
    end.compact
  end

  def to_s
    @grid.each do |row|
      row.each do |cell|
        print cell
      end
      puts
    end
  end

  def find_path(start: [0, 0], stop: [@grid.size - 1, @grid[0].size - 1])
    graph = {}
    @grid.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        links = []
        neighbors(x, y).each do |neighbor|
          links << { coordinate: neighbor, risk: @grid[neighbor[0]][neighbor[1]] }
        end
        graph[[x, y]] = links
      end
    end

    seen = Set.new
    queue = [
      { coordinate: start, risk: @grid[start[0]][start[1]] }
    ]

    while queue.size > 0
      current = queue.shift

      return current[:risk] - @grid[start[0]][start[1]] if current[:coordinate] == stop
      next if seen.include? current[:coordinate]

      seen << current[:coordinate]

      graph[current[:coordinate]].each do |neighbor|
        queue << { coordinate: neighbor[:coordinate], risk: current[:risk] + neighbor[:risk] }
      end

      queue = queue.sort_by { |a| a[:risk] }
    end
  end
end

if ARGV.empty?
  Day15.run 'input/day15.txt'
else
  Day15.run 'test/day15.txt'
end
