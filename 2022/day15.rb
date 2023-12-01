#!/usr/bin/env ruby

class Day15
  def self.run(input_file)
    runner = Day15.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    @sensors = parse(input)
  end

  def part_one
    min = {x: 0, y: 0}
    max = {x: 0, y: 0}
    @sensors.each do |sensor|
      min[:x] = [min[:x], sensor.x, sensor.beacon[:x]].min
      min[:y] = [min[:y], sensor.y, sensor.beacon[:y]].min
      max[:x] = [max[:x], sensor.x, sensor.beacon[:x]].max
      max[:y] = [max[:y], sensor.y, sensor.beacon[:y]].max
    end

    locations = 0
    y = 2000000

    ((min[:x])..(max[:x])).each do |x|
      sensor = @sensors.find do |s|
        s.within_beacon_range?(x: x, y: y)
      end
      locations += 1 if sensor
    end

    beacons_on_line = @sensors.find_all do |s|
      s.beacon[:y] == y
    end.map { |s| s.beacon }.uniq!

    locations - beacons_on_line.count
  end

  def part_two
    @sensors.each do |sensor|
      (0..(sensor.beacon_distance)).each do |dx|
        [-1, 1].permutation(2).each do |mx, my|
          dy = sensor.beacon_distance + 1 - dx
          x = sensor.x + dx * mx
          y = sensor.y + dy * my

          next if x > 4_000_000 || y > 4_000_000 || x.negative? || y.negative?

          unoccupied = @sensors.find do |s|
            s.within_beacon_range?(x: x, y: y)
          end.nil?

          return (x * 4_000_000) + y if unoccupied
        end
      end
    end
  end

  def parse(input)
    sensors = []
    input.each do |info|
      /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/ =~ info
      coords =  Regexp.last_match.captures.map(&:to_i)
      sensor = Sensor.new(x: coords.shift, y: coords.shift)
      sensor.beacon = {
        x: coords.shift,
        y: coords.shift
      }

      sensors << sensor
    end

    sensors
  end
end

class Sensor
  attr_reader :x, :y
  attr_accessor :beacon

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def distance(x:, y:)
    (@x - x).abs + (@y - y).abs
  end

  def beacon_distance
    @beacon_distance ||= distance(**@beacon)
  end

  def within_beacon_range?(x:, y:)
    distance(x: x, y: y) <= beacon_distance
  end

  def to_s
    "Sensor at #{@x}, #{@y}: closest beacon is at #{@beacon}. Distance is #{beacon_distance}"
  end
end

if ARGV.empty?
  Day15.run 'input/day15.txt'
else
  Day15.run 'test/day15.txt'
end
