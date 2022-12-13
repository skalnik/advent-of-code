#!/usr/bin/env ruby
require 'set'

class Day12
  def self.run(input_file)
    runner = Day12.new(input_file)
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
    grid = Grid.new(@input)

    grid.find_path(any_a: true)
  end
end

class Grid
  attr_reader :grid

  def initialize(lines)
    @grid = lines.map do |line|
      line.chars
    end
  end

  def start_coord
    @grid.each_with_index do |row, x|
      if (y = row.find_index('S'))
        return [x, y]
      end
    end
  end

  def all_as
    coords = []
    @grid.each_with_index do |row, x|
      row.each_with_index do |height, y|
        coords << [x, y] if height == 'a'
      end
    end

    coords
  end

  def end_coord
    @grid.each_with_index do |row, x|
      if (y = row.find_index('E'))
        return [x, y]
      end
    end
  end

  def neighbors(x, y)
    neighbors = [[1, 0], [0, 1], [-1, 0], [0, -1]]

    neighbors.map do |(dx, dy)|
      new_x = x + dx
      new_y = y + dy

      next if new_x.negative? || new_x >= @grid.size
      next if new_y.negative? || new_y >= @grid[0].size

      [new_x, new_y]
    end.compact
  end

  def find_path(start: start_coord, stop: end_coord, any_a: false)
    seen = Set.new
    queue = [{ coordinates: start, steps: 0 }]
    if any_a
      all_as.each do |a|
        queue << { coordinates: a, steps: 0 }
      end
    end

    until queue.empty?
      current = queue.shift
      return current[:steps] if current[:coordinates] == stop

      next if seen.include? current[:coordinates]

      seen << current[:coordinates]

      coords = current[:coordinates]
      neighbors(*coords).each do |neighbor|
        current_height = @grid[coords[0]][coords[1]]
        current_height = 'a' if current_height == 'S'

        neighbor_height = @grid[neighbor[0]][neighbor[1]]
        neighbor_height = 'z' if neighbor_height == 'E'

        if current_height.ord + 1 >= neighbor_height.ord
          queue << { coordinates: neighbor, steps: current[:steps] + 1 }
        end
      end
    end
  end
end

if ARGV.empty?
  Day12.run 'input/day12.txt'
else
  Day12.run 'test/day12.txt'
end
