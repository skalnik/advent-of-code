#!/usr/bin/env ruby

class Day22
  def self.run(input_file)
    runner = Day22.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    reactor = Reactor.new
    @input.each do |line|
      if line =~ /(on|off) x=(-?\d+)\.{2}(-?\d+),y=(-?\d+)\.{2}(-?\d+),z=(-?\d+)\.{2}(-?\d+)/
        ($2.to_i..$3.to_i).each do |x|
          next if x < -50 || x > 50
          ($4.to_i..$5.to_i).each do |y|
            next if y < -50 || y > 50
            ($6.to_i..$7.to_i).each do |z|
              next if z < -50 || z > 50

              if $1 == "on"
                reactor.turn_on(x, y, z)
              else
                reactor.turn_off(x, y, z)
              end
            end
          end
        end
      end
    end

    reactor.turned_on_cubes
  end

  def part_two
    reactor = Reactor.new
    @input.each do |line|
      if line =~ /(on|off) x=(-?\d+)\.{2}(-?\d+),y=(-?\d+)\.{2}(-?\d+),z=(-?\d+)\.{2}(-?\d+)/
        ($2.to_i..$3.to_i).each do |x|
          ($4.to_i..$5.to_i).each do |y|
            ($6.to_i..$7.to_i).each do |z|

              if $1 == "on"
                reactor.turn_on(x, y, z)
              else
                reactor.turn_off(x, y, z)
              end
            end
          end
        end
      end
    end

    reactor.turned_on_cubes
  end
end

class Reactor
  def initialize
    @cuboids = Hash.new(false)
  end

  def turn_on(x, y, z)
    @cuboids[[x, y, z]] = true
  end

  def turn_off(x, y, z)
    @cuboids[[x, y, z]] = false
  end

  def turned_on_cubes
    @cuboids.values.count(&:itself)
  end
end

class Cuboid
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def intersect?(cuboid)
    @x.to_a & cuboid.x.to_a > 1 ||
    @y.to_a & cuboid.y.to_a > 1 ||
    @z.to_a & cuboid.z.to_a > 1
  end

  def split(cuboid)
    cuboids = []

    all_x = [@x.min, @x.max, cuboid.x.min, cuboid.x.max].uniq.sort
  end

  def cubes
    @x.size * @y.size * @z.size
  end
end

if ARGV.empty?
  Day22.run 'input/day22.txt'
else
  Day22.run 'test/day22.txt'
end
