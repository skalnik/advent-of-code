#!/usr/bin/env ruby

class Day8
  def self.run(input_file)
    registers = Hash.new(0)
    max_seen = -1

    File.open(input_file).each_line do |raw_instruction|
      instruction_bits = raw_instruction.split(' ')

      register = instruction_bits[0].to_sym
      inc = instruction_bits[1] == 'inc'
      amount = instruction_bits[2].to_i
      condition = instruction_bits[4..6]

      value_at_condition = registers[condition[0].to_sym]
      evaluated = value_at_condition.send(condition[1].to_sym, condition[2].to_i)

      if evaluated
        amount *= -1 unless inc
        registers[register] += amount
        max_seen = [registers[register], max_seen].max
      end
    end

    puts registers.values.max
    puts max_seen
  end
end

Day8.run 'input/day8.txt' if __FILE__ == $0
