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
    school = nil
    File.open(@filename) do |file|
      ages = file.readlines(chomp: true)[0].split(",").map(&:to_i)
      fish = ages.map { |age| Fish.new(age) }
      school = School.new(fish)
    end

    256.times do
      school.step
    end

    school.size
  end
end

class School
  attr_reader :fish
  def initialize(fish)
    @fish = Array.new(9, 0)
    fish.each do |f|
      @fish[f.age] += 1
    end
  end

  def step
    fish = Array.new(9, 0)
    @fish = @fish.each_with_index do |count, age|
      f = Fish.new(age)
      fish[8] += count if f.increment
      fish[f.age] += count
    end

    @fish = fish
  end

  def size
    @fish.sum
  end
end

class Fish
  attr_reader :age
  def initialize(age)
    @age = age
  end

  def increment
    new_fish = false

    if @age > 0
      @age -= 1
    else
      @age = 6
      new_fish = true
    end

    new_fish
  end
end

Day6.run 'input/day6.txt' if __FILE__ == $0
