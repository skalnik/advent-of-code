#!/usr/bin/env ruby

class Day9
  def self.run(input_file)
    runner = Day9.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    grid = {}
    grid[[0, 0]] = true # Tail begins at start location

    head = [0, 0]
    tail = [0, 0]
    @input.each do |instruction|
      vector = parse_instruction(instruction)

      vector[:magnitude].times do
        x, y = *head
        head = [
          x + vector[:dx],
          y + vector[:dy]
        ]

        next if touching?(head, tail)

        tail_dx, tail_dy = *calculate_direction(head, tail)
        tail_x, tail_y = *tail
        tail = [
          tail_x + tail_dx,
          tail_y + tail_dy
        ]
        grid[tail] = true
      end
    end

    grid.each_value.count
  end

  def part_two
    grid = {}
    grid[[0, 0]] = true # Tail begins at start location

    knots = (0...10).map do
      [0, 0]
    end

    @input.each do |instruction|
      vector = parse_instruction(instruction)

      vector[:magnitude].times do
        x, y = *knots[0]
        knots[0] = [
          x + vector[:dx],
          y + vector[:dy]
        ]

        knots[1..].each_with_index do |knot, idx|
          idx += 1 # Offset index for the slice
          head = knots[idx - 1]
          next if touching?(head, knot)

          tail_dx, tail_dy = *calculate_direction(head, knot)
          tail_x, tail_y = *knot
          knots[idx] = [
            tail_x + tail_dx,
            tail_y + tail_dy
          ]
          grid[knots[idx]] = true if idx == knots.length - 1
        end
      end
    end

    grid.each_value.count
  end

  def parse_instruction(instruction)
    dir = instruction.chars[0]
    dist = instruction.chars[2..instruction.length].join.to_i
    dx = 0
    dy = 0

    case dir
    when 'R'
      dy = 1
    when 'L'
      dy = -1
    when 'U'
      dx = 1
    when 'D'
      dx = -1
    end

    {
      dx: dx,
      dy: dy,
      magnitude: dist
    }
  end

  def touching?(cell1, cell2)
    neighbors = [
      [-1, 1],  [0, 1],  [1, 1],
      [-1, 0],  [0, 0],  [1, 0],
      [-1, -1], [0, -1], [1, -1]
    ]

    neighbors.find do |(dx, dy)|
      neighbor = [cell1[0] + dx, cell1[1] + dy]
      neighbor == cell2
    end
  end

  def calculate_direction(head, tail)
    dx = head[0] - tail[0]
    dy = head[1] - tail[1]

    if dx.zero?
      dir = dy.positive? ? -1 : 1
      [dx, dy + dir]
    elsif dy.zero?
      dir = dx.positive? ? -1 : 1
      [dx + dir, dy]
    else
      [dx.positive? ? 1 : -1, dy.positive? ? 1 : -1]
    end
  end

  def print_grid(grid:, knots:, visited: false)
    max_x = [grid.each_key.map { |k| k[0] }.max, 5].max + 10
    max_y = [grid.each_key.map { |k| k[1] }.max, 5].max + 10
    min_x = [grid.each_key.map { |k| k[0] }.min, 0].min - 10
    min_y = [grid.each_key.map { |k| k[1] }.min, 0].min - 10

    str = ''
    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        if visited
          if [x, y] == [0, 0]
            str << 's'
          elsif grid[[x, y]]
            str << '#'
          else
            str << '.'
          end
        else
          if knots[0] == [x, y]
            str << 'H'
          elsif knots[1..].include? [x, y]
            str << '#'
          elsif [x, y] == [0, 0]
            str << 's'
          else
            str << '.'
          end
        end
      end
      str << "\n"
    end

    puts
    puts str.split("\n").reverse.join("\n")
    puts
  end
end

if ARGV.empty?
  Day9.run 'input/day9.txt'
else
  Day9.run 'test/day9.txt'
end
