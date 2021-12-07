#!/usr/bin/env ruby

class Day7
  def self.run(input_file)
    puts "Part 1: #{Day7.new(input_file).part_one}"
    puts "Part 2: #{Day7.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    File.open(@filename) do |file|
      positions = file.readlines[0].split(",").map(&:to_i)
      min, max  = positions.min, positions.max

      min_fuel_cost = max * positions.size

      (min..max).each do |position|
        fuel_cost = positions.inject(0) do |cost, crab|
          cost += (crab - position).abs
        end
        if fuel_cost < min_fuel_cost
          min_fuel_cost = fuel_cost
        end
      end

      min_fuel_cost
    end
  end

  def part_two
    File.open(@filename) do |file|
      positions = file.readlines[0].split(",").map(&:to_i)
      min, max  = positions.min, positions.max

      min_fuel_cost = nil

      (min..max).each do |position|
        fuel_cost = positions.inject(0) do |cost, crab|
          distance = (crab - position).abs
          cost += distance * ((distance.to_f + 1) / 2)
        end

        min_fuel_cost = fuel_cost if min_fuel_cost.nil?

        if fuel_cost < min_fuel_cost
          min_fuel_cost = fuel_cost
        end
      end

      min_fuel_cost
    end
  end
end

Day7.run 'input/day7.txt' if __FILE__ == $0
