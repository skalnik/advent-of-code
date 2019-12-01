#!/usr/bin/env ruby

class Day1
  def self.run(input_file)
    adjustments = []
    File.read(input_file).each_line do |adjustment|
      adjustments << [adjustment[0], adjustment[1..-1].to_i]
    end

    frequency = 0
    frequencies = [0]
    repeated = false

    while !repeated
      adjustments.each do |direction, amount|
        frequency = frequency.send(direction, amount)

        if frequencies.include?(frequency)
          puts "Reached #{frequency} twice"
          repeated = true
          break
        end

        frequencies << frequency
      end

      puts "Finished a pass through all adjustments: #{frequency}"
    end
  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
