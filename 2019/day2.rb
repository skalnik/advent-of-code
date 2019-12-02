#!/usr/bin/env ruby

class Day2
  def self.run(input_file)
    intcode = File.read(input_file).chomp.split(',').map(&:to_i)
    puts "Part 1: #{Day2.new(intcode).run}"
    puts "Part 2: #{Day2.new(intcode).run(part: 2)}"
  end

  def initialize(intcode)
    @intcode = intcode
  end

  def run(part: 1)
    if part == 1
      process(@intcode.clone, 12, 2)
    else
      (0..99).each do |noun|
        (0..99).each do |verb|
          output = process(@intcode.clone, noun, verb)

          return 100 * noun + verb if output == 19690720
        end
      end
    end
  end

  def process(intcode, noun, verb)
    intcode[1] = noun
    intcode[2] = verb

    position = 0
    done = false

    until done do
      opcode = intcode[position]

      case opcode
      when 99
        done = true
      when 1
        register1 = intcode[position + 1]
        register2 = intcode[position + 2]
        register3 = intcode[position + 3]
        intcode[register3] = intcode[register1] + intcode[register2]
        position = position + 4
      when 2
        register1 = intcode[position + 1]
        register2 = intcode[position + 2]
        register3 = intcode[position + 3]
        intcode[register3] = intcode[register1] * intcode[register2]
        position = position + 4
      else
        puts "AH got opcode: #{opcode}"
        exit
      end
    end

    intcode[0]
  end
end

Day2.run 'input/day2.txt' if __FILE__ == $0
