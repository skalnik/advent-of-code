#!/usr/bin/env ruby

class Day21
  def self.run(input_file)
    runner = Day21.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
    @games = {}
  end

  def part_one
    players = []
    input = @input.dup
    if input.shift =~ /Player (\d) starting position: (\d+)/
      players << Player.new(id: $1, position: $2.to_i)
    end

    if input.shift =~ /Player (\d) starting position: (\d+)/
      players << Player.new(id: $1, position: $2.to_i)
    end

    die = Die.new
    until players.any?(&:won?)
      player = players.shift
      players << player
      player.move_forward(die.roll_three_times)
    end

    players.find(&:losing?).points * die.rolls
  end

  def part_two
    players = []
    input = @input.dup
    if input.shift =~ /Player (\d) starting position: (\d+)/
      players[$1.to_i - 1] = {
        position: $2.to_i,
        score: 0
      }
    end

    if input.shift =~ /Player (\d) starting position: (\d+)/
      players[$1.to_i - 1] = {
        position: $2.to_i,
        score: 0
      }
    end

    game = {
      players: players,
      turn: 0
    }

    wins_from(game)
  end


  def wins_from(game)
    return @games[game] if @games[game]

    if game[:players].any? { |p| p[:score] >= 21 }
      if game[:players].first[:score] >= 21
        return [1, 0]
      else
        return [0, 1]
      end
    end

    dirac_die = [1, 2, 3]
    rolls = dirac_die.product(dirac_die, dirac_die)

    wins = rolls.map do |roll|
      new_game = {
        players: [
          game[:players].first.dup,
          game[:players].last.dup
        ],
        turn: game[:turn].dup
      }

      current_player = new_game[:players][new_game[:turn]]
      new_position = (((current_player[:position] + roll.sum) - 1) % 10) + 1
      current_player[:position] = new_position
      current_player[:score] += new_position
      new_game[:turn] = (new_game[:turn] + 1) % 2

      wins_from(new_game)
    end

    @games[game] = wins.transpose.map(&:sum)
    @games[game]
  end
end

class Player
  attr_reader :points, :id, :position

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

