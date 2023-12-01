#!/usr/bin/env ruby

class Day1
  def self.run(input_file)
    puts "Part 1: #{Day1.new(input_file).part_one}"
    puts "Part 2: #{Day1.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    calibration_values = 0
    File.open(@filename) do |file|
      file.each_line do |line|
        values = line.scan(/\d/)
        next if values.size < 2 
        value = Integer(values.first + values.last)
        calibration_values += value
      end
    end

    calibration_values
  end

  def part_two
    map = {
      zero: 0,
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6,
      seven: 7,
      eight: 8,
      nine: 9
    }
    File.open(@filename) do |file|
      calibration_values = 0
      file.each_line do |line|
        regex = /(#{map.keys.join("|")}|\d)/
        values = line.scan(/(?=(#{map.keys.join("|")}|\d))/).flatten
        values = values.map do |v|
          if v !~ /\d/
            map[v.to_sym].to_s
          else 
            v
          end
        end

        calibration_values += Integer(values.first + values.last)
      end

      calibration_values
    end
  end
end

if __FILE__ == $0
  if ARGV.empty?
    Day1.run 'input/day1.txt'
  else
    Day1.run ARGV.first
  end
end
