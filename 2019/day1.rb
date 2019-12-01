#!/usr/bin/env ruby

class Day1
  def self.run(input_file)
    puts "Part 1: #{Day1.new(input_file).run}"
    puts "Part 2: #{Day1.new(input_file).run(part: 2)}"
  end

  def initialize(filename)
    @filename = filename
  end

  def run(part: 1)
    total = 0
    File.open(@filename) do |file|
      file.each_line do |mass|
        fuel_required = (mass.chomp.to_i / 3) - 2
        total += fuel_required

        if part == 2
          while (fuel_required = (fuel_required / 3) - 2) > 0
            total += fuel_required
          end
        end
      end
    end
    
    total
  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
