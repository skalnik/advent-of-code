#!/usr/bin/env ruby

class Day3
  DIRECTION_MAP = {
    L: [-1, 0],
    R: [1, 0],
    U: [0, 1],
    D: [0, -1]
  }

  def self.run(input_file)
    wire1, wire2 = *File.read(input_file).split("\n")
    wire1 = wire1.split(",")
    wire2 = wire2.split(",")

    solver = Day3.new(wire1, wire2)

    puts "Part 1: #{solver.run}"
    puts "Part 2: #{solver.run(part: 2)}"
  end

  def initialize(wire1, wire2)
    @points1 = process(wire1)
    @points2 = process(wire2)

    @shared_points = @points1.keys & @points2.keys
  end

  def run(part: 1)
    if part == 1
      distances = @shared_points.map do |(x, y)|
        x.abs + y.abs
      end

      distances.min
    else
      lengths = @shared_points.map do |position|
        @points1[position] + @points2[position]
      end

      lengths.min
    end
  end

  def process(wire)
    position = [0, 0]
    length = 0
    points = {}

    wire.each do |instruction|
      direction = instruction[0].to_sym
      distance = instruction[1..-1].to_i

      distance.times do
        position[0] += DIRECTION_MAP[direction][0]
        position[1] += DIRECTION_MAP[direction][1]
        length += 1

        points[position.clone] = length unless points[position]
      end
    end

    points
  end
end

Day3.run 'input/day3.txt' if __FILE__ == $0
