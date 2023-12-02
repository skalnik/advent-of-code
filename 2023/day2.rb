#!/usr/bin/env ruby

class Day2
  def self.run(input_file)
    puts "Part 1: #{Day2.new(input_file).part_one}"
    puts "Part 2: #{Day2.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    bag = Bag.new(red: 12, green: 13, blue: 14)
    id_sum = 0

    File.open(@filename) do |file|
      file.each_line do |line|
        id = line.match(/Game (\d+)/).captures.first.to_i
        game_possible = true

        line = line.sub(/Game \d+: /, '')
        line.split(";").each do |info|
          info_set = { red: 0, blue: 0, green: 0 }
          info.scan(/(\d+) (red|blue|green)/) do |set|
            case set[1]
            when 'red'
              info_set[:red] = set[0].to_i
            when 'blue'
              info_set[:blue] = set[0].to_i
            when 'green'
              info_set[:green] = set[0].to_i
            end
          end
          #puts "Game #{id}: #{info_set}, and possible? #{bag.possible?(**info_set)}"
          game_possible = false unless bag.possible?(**info_set)
        end

        id_sum += id if game_possible
      end
    end

    id_sum
  end

  def part_two
    power_sum = 0

    File.open(@filename) do |file|
      file.each_line do |line|
        mins = { red: 0, blue: 0, green: 0 }

        line = line.sub(/Game \d+: /, '')
        line.split(";").each do |info|
          info.scan(/(\d+) (red|blue|green)/) do |set|
            case set[1]
            when 'red'
              mins[:red] = set[0].to_i if set[0].to_i > mins[:red]
            when 'blue'
              mins[:blue] = set[0].to_i if set[0].to_i > mins[:blue]
            when 'green'
              mins[:green] = set[0].to_i if set[0].to_i > mins[:green]
            end
          end
        end

        power = mins.values.inject(:*)
        power_sum += power
      end
    end

    power_sum
  end
end

class Bag
  def initialize(red: 0, green: 0, blue: 0)
    @red = red
    @green = green
    @blue = blue
  end

  def possible?(red:, green:, blue:)
    @red >= red && @green >= green && @blue >= blue
  end
end

if __FILE__ == $0
  if ARGV.empty?
    Day2.run 'input/day2.txt'
  else
    Day2.run ARGV.first
  end
end
