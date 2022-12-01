#!/usr/bin/env ruby

class Day25
  def self.run(input_file)
    runner = Day25.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    cucumbers = SeaCucumbers.new(data: @input.map(&:chars))
    2.times do
      puts "After #{cucumbers.step_count}"
      puts cucumbers
      cucumbers.step!
      puts "*" * 100
    end

    cucumbers.step_count - 1
  end

  def part_two
  end
end

class SeaCucumbers
  attr_reader :x, :y, :step_count
  attr_accessor :stepped
  alias_method :stepped?, :stepped

  def initialize(max_x: 0, max_y: 0, step: 0, data: nil)
    @x, @y = max_x, max_y
    @step_count = step

    @grid = Hash.new('.')

    # Initialization is a step
    @stepped = true if step == 0

    if data
      @x = data.size
      @y = data[0].size

      data.each_with_index do |row, x|
        row.each_with_index do |cucumber, y|
          @grid[[x, y]] = cucumber unless cucumber == '.'
        end
      end
    end
  end

  def step!
    new_grid = Hash.new('.')
    @stepped = false

    (0...@x).each do |x|
      (0...@y).each do |y|
        next if @grid[[x, y]] != '>'
        neighbor = [ (x + 1) % @x, y]

        if @grid[neighbor] == '.'
          @stepped = true
          new_grid[neighbor] = '>'
        else
          new_grid[[x, y]] = '>'
        end
      end
    end

    (0...@x).each do |x|
      (0...@y).each do |y|
        next if @grid[[x, y]] != 'v'
        neighbor = [ x, (y + 1) % @y ]

        if new_grid[neighbor] == '.'
          @stepped = true
          new_grid[neighbor] = 'v'
        else
          new_grid[[x, y]] = 'v'
        end
      end
    end

    @step_count += 1 if @stepped
    @grid = new_grid
  end

  def to_s
    str = ""
    (0...@x).each do |x|
      (0...@y).each do |y|
        str << @grid[[x, y]]
      end
      str << "\n"
    end

    str
  end
end

if ARGV.empty?
  Day25.run 'input/day25.txt'
else
  Day25.run 'test/day25.txt'
end

