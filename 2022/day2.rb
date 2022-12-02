#!/usr/bin/env ruby

class Day2
  def self.run(input_file)
    runner = Day2.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    @input.inject(0) do |score, game|
      p1 = game[0]
      p2 = game[2]
      score + score_game(p1, p2)
    end
  end

  def part_two
    @input.inject(0) do |score, game|
      p1 = game[0]
      outcome = game[2]
      score + score_game_outcome(p1, outcome)
    end
  end

  def score_game(p1, p2)
    start_score = {
      'X': 1,
      'Y': 2,
      'Z': 3
    }

    game_score = {
      'A': {
        'X': 3,
        'Y': 6,
        'Z': 0
      },
      'B': {
        'X': 0,
        'Y': 3,
        'Z': 6
      },
      'C': {
        'X': 6,
        'Y': 0,
        'Z': 3
      }
    }

    start_score[p2.to_sym] + game_score[p1.to_sym][p2.to_sym]
  end

  def score_game_outcome(p1, outcome)
    outcome_score = {
      'X': 0,
      'Y': 3,
      'Z': 6
    }

    hand_score = {
      'A': { # Rock
        'X': 3, # Lose with scissors
        'Y': 1, # Tie with Rock
        'Z': 2, # Win with paper
      },
      'B': { # Paper
        'X': 1, # Lose with rock
        'Y': 2, # Tie with paper
        'Z': 3, # Win with scissors
      },
      'C': { # Scissors
        'X': 2, # Lose with paper
        'Y': 3, # Tie with scissors
        'Z': 1, # Win with rock
      }
    }

    outcome_score[outcome.to_sym] + hand_score[p1.to_sym][outcome.to_sym]
  end
end

if ARGV.empty?
  Day2.run 'input/day2.txt'
else
  Day2.run 'test/day2.txt'
end
