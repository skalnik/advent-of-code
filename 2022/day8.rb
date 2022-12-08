#!/usr/bin/env ruby

# 1197 is too low
# 1221 is too low

class Day8
  def self.run(input_file)
    runner = Day8.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    @grid = construct_grid(input)
  end

  def part_one
    count = 0

    @grid.each_with_index do |row, y|
      row.each_with_index do |tree, x|
        if x.zero? || x == (@grid.length - 1) ||
           y.zero? || y == (row.length - 1)
          # All edge trees are visible
          count += 1
        else
          neighbors = get_trees_to_edge(x, y)
          count += 1 if neighbors.each_value.any? { |dir| dir.all? { |t| t < tree } }
        end
      end
    end

    count
  end

  def part_two
    max_score = -1
    @grid.each_with_index do |row, y|
      row.each_with_index do |_, x|
        score = scenic_score(x, y)
        max_score = [score, max_score].max
      end
    end

    max_score
  end

  def construct_grid(input)
    input.map(&:chars).map { |r| r.map(&:to_i) }
  end

  def scenic_score(x, y)
    return 0 if x.zero? || x == (@grid.length - 1) || y.zero? || y == (@grid[0].length - 1)

    height = @grid[y][x]
    neighbors = get_trees_to_edge(x, y)
    scenic_score = 1
    neighbors.each_pair do |_, line|
      # lmao effiency
      blocked_at = if line.any? { |t| t >= height }
        line.find_index { |t| t >= height } + 1
      else
        line.length
      end

      scenic_score *= blocked_at
    end

    scenic_score
  end

  def get_trees_to_edge(x, y)
    neighbors = {
      up: [],
      down: [],
      left: [],
      right: []
    }

    (0..(x - 1)).each do |nx|
      neighbors[:left] << @grid[y][nx]
    end
    neighbors[:left].reverse!

    ((x + 1)...@grid.length).each do |nx|
      neighbors[:right] << @grid[y][nx]
    end

    (0..(y - 1)).each do |ny|
      neighbors[:up] << @grid[ny][x]
    end
    neighbors[:up].reverse!

    ((y + 1)...@grid[0].length).each do |ny|
      neighbors[:down] << @grid[ny][x]
    end

    neighbors.delete_if { |_, v| v.empty? }
  end
end

if ARGV.empty?
  Day8.run 'input/day8.txt'
else
  Day8.run 'test/day8.txt'
end
