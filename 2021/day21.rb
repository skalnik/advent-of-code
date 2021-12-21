#!/usr/bin/env ruby

class Day21
  def self.run(input_file)
    runner = Day21.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    @players = []
    if input.shift =~ /Player (\d) starting position: (\d+)/
      @players << Player.new(id: $1, position: $2.to_i)
    end

    if input.shift =~ /Player (\d) starting position: (\d+)/
      @players << Player.new(id: $1, position: $2.to_i)
    end
  end

  def part_one
    die = Die.new
    until @players.any?(&:won?)
      player = @players.shift
      @players << player
      player.move_forward(die.roll_three_times)
    end

    @players.find(&:losing?).points * die.rolls
  end

  def part_two
  end
end

class Player
  attr_reader :points, :id

  def initialize(position:, id:)
    @id = id
    @position = position
    @points = 0
  end

  def move
    @position += 1

    @position = 1 if @position > 10

  end

  def move_forward(spaces)
    spaces.times { self.move }

    @points += @position
  end

  def won?
    @points >= 1000
  end

  def losing?
    !won?
  end
end

class Die
  attr_reader :side, :rolls

  def initialize
    @side = 0
    @rolls = 0
  end

  def roll
    @rolls += 1
    @side += 1

    @side = 1 if @side > 100

    @side
  end

  def roll_three_times
    rolls = [self.roll, self.roll, self.roll]
    rolls.sum
  end
end

if ARGV.empty?
  Day21.run 'input/day21.txt'
else
  Day21.run 'test/day21.txt'
end

