#!/usr/bin/env ruby

class Day2
  def self.run(input_file)
    puts "Part 1: #{Day2.new(input_file).part_one}"
    puts "Part 2: #{Day2.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    position = { x: 0, y: 0 }
    File.open(@filename) do |file|
      file.each_line do |line|
        movement = translate(line: line)
        position[:x] += movement[:x]
        position[:y] += movement[:y]
      end
    end

    position[:x] * position[:y]
  end

  def part_two
    position = { x: 0, y: 0, aim: 0 }
    File.open(@filename) do |file|
      file.each_line do |line|
        position = translate_with_aim(line: line, position: position)
      end
    end

    position[:x] * position[:y]
  end

  def translate(line:)
    direction, amount = line.split
    amount = Integer(amount)
    movement = { x: 0, y: 0 }

    case direction
    when "forward"
      movement[:x] = amount
    when "up"
      movement[:y] = amount * -1
    when "down"
      movement[:y] = amount
    end

    movement
  end

  def translate_with_aim(line:, position:)
    direction, amount = line.split
    amount = Integer(amount)

    case direction
    when "forward"
      position[:x] += amount
      position[:y] += amount * position[:aim]
    when "up"
      position[:aim] -= amount
    when "down"
      position[:aim] += amount
    end

    position
  end
end

Day2.run 'input/day2.txt' if __FILE__ == $0
