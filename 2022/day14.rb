#!/usr/bin/env ruby

# 9763 too low

class Day14
  def self.run(input_file)
    runner = Day14.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    cave = Cave.new(@input)
    grains = 0
    puts cave.to_s
    while cave.drop_sand
      grains += 1
    end

    puts cave.to_s

    grains
  end

  def part_two
    cave = Cave.new(@input, floor: true)
    grains = 1 # Extra 1 for the source
    puts cave.to_s

    while cave.drop_sand
      grains += 1
    end

    puts cave.to_s

    grains
  end
end

class Cave
  SOURCE = [500, 0]
  attr_reader :grid, :floor

  def initialize(paths, floor: false)
    @grid = Hash.new { '.' }
    paths.each do |path|
      points = path.scan(/(\d+),(\d+)(?: -> )?/).map { |x, y| [x.to_i, y.to_i] }
      points.each_cons(2) do |start, destination|
        @grid[start] = '#'

        dx = destination[0] <=> start[0]
        dy = destination[1] <=> start[1]

        current = start.dup
        until current == destination
          current = [current[0] + dx, current[1] + dy]
          @grid[current] = '#'
        end
      end
    end

    if floor
      @floor = true
      bbox = bounding_box
      floor = bbox[:y].max + 2
      old_grid = @grid.dup

      @grid = Hash.new { |h, k| k[1] == floor ? '#' : '.' }

      (-20..20).each do |dx|
        @grid[[500 + dx, floor]] = '#'
      end

      old_grid.each_pair do |k, v|
        @grid[k] = v
      end
    end
  end

  def to_s
    str = ""
    bbox = bounding_box

    bbox[:y].each do |y|
      bbox[:x].each do |x|
        if SOURCE == [x, y]
          str << '+'
        else
          str << @grid[[x, y]]
        end
      end
      str << "\n"
    end

    str
  end

  def bounding_box
    min = [500, 0]
    max = [500, 0]
    @grid.each_key do |(x, y)|
      min[0] = [min[0], x].min
      max[0] = [max[0], x].max

      min[1] = [min[1], y].min
      max[1] = [max[1], y].max
    end

    {
      x: (min[0]..max[0]),
      y: (min[1]..max[1])
    }
  end

  def drop_sand
    moved = true
    sand = SOURCE.dup
    bbox = bounding_box.dup

    while moved
      moved = false

      below = [sand[0], sand[1] + 1]
      if !@floor && !within_bounds?(*below, bbox: bbox)
        sand = SOURCE
        next
      end

      if @grid[below] == '.'
        moved = true
        sand = below
        next
      end

      diagonal_left = [below[0] - 1, below[1]]
      if !@floor && !within_bounds?(*diagonal_left, bbox: bbox)
        sand = SOURCE
        next
      end

      if @grid[diagonal_left] == '.'
        moved = true
        sand = diagonal_left
        next
      end

      diagonal_right = [below[0] + 1, below[1]]
      if !@floor && !within_bounds?(*diagonal_right, bbox: bbox)
        sand = SOURCE
        next
      end

      if @grid[diagonal_right] == '.'
        moved = true
        sand = diagonal_right
        next
      end
    end

    return false if SOURCE == sand

    @grid[sand] = 'o'
    true
  end

  def within_bounds?(x, y, bbox: bounding_box)
    bbox[:x].include?(x) && bbox[:y].include?(y)
  end
end

if ARGV.empty?
  Day14.run 'input/day14.txt'
else
  Day14.run 'test/day14.txt'
end
