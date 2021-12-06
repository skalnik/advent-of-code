#!/usr/bin/env ruby

class Day6
  def self.run(input_file)
    puts "Part 1: #{Day6.new(input_file).part_one}"
    puts "Part 2: #{Day6.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    school = nil
    File.open(@filename) do |file|
      ages = file.readlines(chomp: true)[0].split(",").map(&:to_i)
      fish = ages.map { |age| Fish.new(age) }
      school = School.new(fish)
    end

    80.times do
      school.step
    end

    school.size
  end

  def part_two
  end
end

class School
  attr_reader :fish
  def initialize(fish)
    @fish = fish
  end

  def step
    new_fish = []
    @fish.each do |fish|
      if fish.increment
        new_fish << Fish.new(8)
      end
    end

    @fish = @fish + new_fish
  end

  def size
    @fish.size
  end
end

class Fish
  attr_reader :day
  def initialize(day)
    @day = day
  end

  def increment
    if @day > 0
      @day -= 1
      return false
    else
      @day = 6
      return true
    end
  end
end

Day6.run 'input/day6.txt' if __FILE__ == $0
