#!/usr/bin/env ruby

class Day5
  def self.run(input_file)
    intcode = File.read(input_file).chomp.split(',').map(&:to_i)
    puts "*** Part 1 ***"
    Day5.new(intcode).run(1)
    puts "*** Part 2 ***"
    Day5.new(intcode).run(5)
  end

  def initialize(intcode)
    @intcode = intcode
  end

  def run(input)
    @input = input
    process(@intcode.clone)
  end

  def process(intcode)
    position = 0
    done = false

    until done do
      instruction = intcode[position]

      if instruction == 99
        done = true
        break
      end

      instruction = instruction.to_s.chars.map(&:to_i)
      opcode = instruction.pop
      instruction.pop # Leading 0

      parameter_modes = instruction.reverse
      parameter_modes << 0 while parameter_modes.length < 3

      parameter1 = parameter_modes[0] == 1 ? intcode[position + 1] : intcode[intcode[position + 1]]
      parameter2 = parameter_modes[1] == 1 ? intcode[position + 2] : intcode[intcode[position + 2]]

      case opcode
      when 1
        register = intcode[position + 3]

        intcode[register] = parameter1 + parameter2

        position += 4
      when 2
        register = intcode[position + 3]

        intcode[register] = parameter1 * parameter2

        position += 4
      when 3
        puts "Input: #{@input}"
        register = intcode[position + 1]

        intcode[register] = @input
        position += 2
      when 4
        register = intcode[position + 1]

        puts intcode[register]

        position += 2
      when 5
        if parameter1 != 0
          position = parameter2
        else
          position += 3
        end
      when 6
        if parameter1 == 0
          position = parameter2
        else
          position += 3
        end
      when 7
        parameter3 = parameter_modes[2] == 1 ? position + 3 : intcode[position + 3]

        if parameter1 < parameter2
          intcode[parameter3] = 1
        else
          intcode[parameter3] = 0
        end

        position += 4
      when 8
        parameter3 = parameter_modes[2] == 1 ? position + 3 : intcode[position + 3]

        if parameter1 == parameter2
          intcode[parameter3] = 1
        else
          intcode[parameter3] = 0
        end

        position += 4
      else
        puts "AH got opcode: #{opcode}"
        exit
      end
    end

    intcode[0]
  end
end

Day5.run 'input/day5.txt' if __FILE__ == $0

