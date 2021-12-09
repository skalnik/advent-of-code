#!/usr/bin/env ruby

class Day9
  def self.run(input_file)
    puts "Part 1: #{Day9.new(input_file).part_one}"
    puts "Part 2: #{Day9.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    heightmap = []
    File.open(@filename) do |file|
      heightmap = file.readlines.map { |s| s.chomp.chars.map(&:to_i) }
    end
    low_points(heightmap).map(&:depth).map(&:next).sum
  end

  def part_two
    heightmap = []
    File.open(@filename) do |file|
      heightmap = file.readlines.map { |s| s.chomp.chars.map(&:to_i) }
    end

    minimums = low_points(heightmap)
    spots_to_check = [[-1, 0], [0, -1], [0, 1], [1, 0]]

    minimums.map do |minimum|
      seen = []
      to_visit = [minimum]
      while point = to_visit.shift
        next if seen.include?(point)
        seen << point

        spots_to_check.each do |diff|
          new_point = Point.new(point.row + diff[0], point.col + diff[1])
          next if new_point.row < 0 || new_point.col < 0 || new_point.row >= heightmap.length || new_point.col >= heightmap[0].length

          new_point.depth = heightmap[new_point.row][new_point.col]
          if new_point.depth < 9 && !seen.include?(new_point)
            to_visit << new_point
          end
        end
      end

      seen.size
    end.max(3).inject(&:*)
  end

  def low_points(grid)
    low_points = []

    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        point = Point.new(r, c, cell)
        lowest = point.possible_neighbors.map do |neighbor|
          next if neighbor.out_of_bounds?(grid.length - 1, grid[0].length - 1)
          point.depth < neighbor.fill_depth(grid)
        end.compact.all?(true)

        low_points << point if lowest
      end
    end

    low_points
  end
end

class Point
  attr_reader :row, :col
  attr_accessor :depth

  def initialize(row, col, depth = 0)
    @row, @col, @depth = row, col, depth
  end

  def ==(other)
    self.row == other.row && self.col == other.col
  end

  def possible_neighbors
    neighboring = [ [-1, 0], [0, -1], [0, 1], [1, 0] ]
    neighboring.map do |(dr, dc)|
      Point.new(row + dr, col + dc)
    end
  end

  def out_of_bounds?(max_row, max_col)
    row < 0 || row > max_row || col < 0 || col > max_col
  end

  def fill_depth(grid)
    @depth = grid[row][col]
  end

  def to_s
    "(#{row}, #{col}): #{depth}"
  end
end

if ARGV.empty?
  Day9.run 'input/day9.txt'
else
  Day9.run 'test/day9.txt'
end
