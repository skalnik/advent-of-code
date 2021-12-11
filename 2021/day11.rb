#!/usr/bin/env ruby

class Day11
  def self.run(input_file)
    puts "Part 1: #{Day11.new(input_file).part_one}"
    puts "Part 2: #{Day11.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    File.open(@filename) do |file|
      octopi = Octopi.new(file.readlines(chomp: true).map(&:chars))

      1.upto(100).inject(0) do |flashes, i|
        flashes + octopi.step
      end
    end
  end

  def part_two
    File.open(@filename) do |file|
      octopi = Octopi.new(file.readlines(chomp: true).map(&:chars))

      flashes = 0
      step = 0
      while flashes < 100
        flashes = octopi.step
        step += 1
      end

      step
    end
  end
end

class Octopus
  attr_reader :energy, :row, :col

  def initialize(energy, row, col)
    @energy, @row, @col = energy, row, col
  end

  def increment
    @energy += 1
  end

  def flashing?
    @energy > 9
  end

  def flash!
    @energy = 0
  end

  def to_s
    if flashing?
      "\033[31m#{@energy - 10}\033[0m"
    else
      "#{@energy}"
    end
  end

  def inspect
    str = "(#{row}, #{col}) "
    if flashing?
      str << "\033[31m#{@energy}\033[0m"
    else
      str << "#{@energy}"
    end
  end

  def ==(other)
    self.row == other.row && self.col == other.col
  end
end

class Octopi
  attr_reader :grid

  def initialize(grid)
    @grid = Array.new(grid.length) { Array.new(grid.length) }

    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        @grid[r][c] = Octopus.new(cell.to_i, r, c)
      end
    end
  end

  def step
    # First, the energy level of each octopus increases by 1.
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        cell.increment
      end
    end

    # Then, any octopus with an energy level greater than 9 flashes. If this
    # causes an octopus to have an energy level greater than 9, it also flashes.
    flashing = []
    @grid.flatten.each do |octopus|
      flashing << octopus if octopus.flashing?
    end

    flashed = []
    while octopus = flashing.shift
      next if flashed.include? octopus
      flashed << octopus

      neighbors(octopus).each do |neighbor|
        neighbor.increment
        flashing << neighbor if neighbor.flashing?
      end
    end

    # Finally, any octopus that flashed during this step has its energy level
    # set to 0, as it used all of its energy to flash.
    @grid.flatten.inject(0) do |flashes, octopus|
      if octopus.flashing?
        octopus.flash!
        flashes += 1
      else
        flashes
      end
    end
  end

  def neighbors(octopus)
    neighbor_cells = [
      [-1, -1], [-1, 0], [-1, 1], 
      [ 0, -1],          [ 0, 1],
      [ 1, -1], [ 1, 0], [ 1, 1]
    ]

    neighbor_cells.map do |diff|
      row, col = octopus.row + diff[0], octopus.col + diff[1]
      next if row < 0 || row >= grid.length || col < 0 || col >= grid[0].length
      @grid[row][col]
    end.compact
  end

  def to_s
    @grid.each do |row|
      row.each do |cell|
        print "#{cell.to_s} "
      end

      puts
    end
  end
end

if ARGV.empty?
  Day11.run 'input/day11.txt'
else
  Day11.run 'test/day11.txt'
end
