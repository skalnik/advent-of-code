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
    spots_to_check = [
      [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
    ]
    low_points = []
    heightmap.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        lowest = spots_to_check.map do |diff|
          to_check = [r - diff[0], c - diff[1]]
          next if to_check[0] < 0 || to_check[1] < 0 || to_check[0] >= heightmap.length || to_check[1] >= row.length
          cell < heightmap[to_check[0]][to_check[1]]
        end.compact.all?(true)
        low_points << [r, c] if lowest
      end
    end

    low_points.map do |low_point|
      basin_size(low_point[0], low_point[1], [])
    end
  end

  def low_points(grid)
    low_points = []
    spots_to_check = [
      [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
    ]

    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        lowest = spots_to_check.map do |diff|
          to_check = [r - diff[0], c - diff[1]]
          next if to_check[0] < 0 || to_check[1] < 0 || to_check[0] >= grid.length || to_check[1] >= row.length
          cell < grid[to_check[0]][to_check[1]]
        end.compact.all?(true)
        low_points << Point.new(r, c, cell) if lowest
      end
    end

    low_points
  end

  def basin_size(x, y, points_seen)
    
  end
end

class Point
  attr_reader :row, :col, :depth

  def initialize(row, col, depth)
    @row, @col, @depth = row, col, depth
  end
end

if ARGV.empty?
  Day9.run 'input/day9.txt'
else
  Day9.run 'test/day9.txt'
end
