#!/usr/bin/env ruby

require 'set'

class Day12
  def self.run(input_file)
    puts "Part 1: #{Day12.new(input_file).part_one}"
    puts "Part 2: #{Day12.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    caves = Caves.new
    File.open(@filename) do |file|
      file.each_line(chomp: true).each do |line|
        connections = line.split("-").map do |c|
          caves.add(Cave.new(c))
        end

        connections[0].connections << connections[1] unless connections[1].start?
        connections[1].connections << connections[0] unless connections[0].start?
      end
    end
    start = caves.cave_named("start")

    caves.paths_to_end(start, Set.new)
  end

  def part_two
    caves = Caves.new
    File.open(@filename) do |file|
      file.each_line(chomp: true).each do |line|
        connections = line.split("-").map do |c|
          caves.add(Cave.new(c))
        end

        connections[0].connections << connections[1] unless connections[1].start?
        connections[1].connections << connections[0] unless connections[0].start?
      end
    end
    start = caves.cave_named("start")

    caves.paths_to_end_extra_time(start, Set.new, nil)
  end
end

class Caves
  attr_reader :caves

  def initialize()
    @caves = {}
  end

  def add(cave)
    c = caves[cave.name]
    if !c
      caves[cave.name] = cave
      c = cave
    end

    c
  end

  def paths_to_end(current_cave, visited)
    return 1 if current_cave.end?

    # We can visit big caves as many times as we want, so no need to keep track
    visited << current_cave if !current_cave.start? && !current_cave.end? && current_cave.small?

    @caves[current_cave.name].connections.map do |connection|
      if visited.include?(connection)
        0
      else
        paths_to_end(connection, visited.dup)
      end
    end.sum
  end

  def paths_to_end_extra_time(current_cave, visited, visited_twice)
    return 1 if current_cave.end?

    if !current_cave.start? && !current_cave.end? && current_cave.small?
      if visited.include? current_cave
        visited_twice = current_cave
      else
        visited << current_cave
      end
    end

    @caves[current_cave.name].connections.map do |connection|
      if visited.include?(connection) && !!visited_twice
        0
      else
        paths_to_end_extra_time(connection, visited.dup, visited_twice)
      end
    end.sum
  end

  def cave_named(name)
    @caves[name]
  end

  def to_s
    caves.values.map do |cave|
      "#{cave}"
    end.join("\n")
  end
end

class Cave
  attr_reader :name, :connections

  def initialize(name)
    @name = name
    @connections = Set.new
  end

  def start?
    @name == "start"
  end

  def end?
    @name == "end"
  end

  def big?
    @name == @name.upcase
  end

  def small?
    !big?
  end

  def ==(other)
    @name == other.name
  end

  def to_s
    "#{@name} -> [#{@connections.map(&:name).join(", ")}]"
  end
end

if ARGV.empty?
  Day12.run 'input/day12.txt'
else
  Day12.run 'test/day12.txt'
end
