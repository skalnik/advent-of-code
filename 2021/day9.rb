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
    spots_to_check = [
      [-1, 0], [0, -1], [0, 1], [1, 0]
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

  def to_s
    "(#{row}, #{col}): #{depth}"
  end
end

if ARGV.empty?
  Day9.run 'input/day9.txt'
else
  Day9.run 'test/day9.txt'
end
