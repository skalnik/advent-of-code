#!/usr/bin/env ruby

class Day24
  def self.run(input_file)
    runner = Day24.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    actors = []
    parent = Ractor.current

    10.times do
      actors << Ractor.new(parent, @input.dup) do |parent, input|
        monad = ModelNumberChecker.new(input)

        while number = Ractor.recv
          puts "Checking #{number}"
          if monad.valid? number
            r.send number
          end
        end
      end
    end

    current_actor = 0
    52926995999999.downto(11111111111111) do |number|
      p actors[current_actor]
      actors[current_actor] << number
      current_actor = (current_actor + 1) % actors.size
    end

    return Ractor.recv
  end

  def part_two
  end
end

class Program
  attr_reader :registers

  def initialize(input, program)
    @input = input.digits
    @program = program
    @registers = { w: 0, x: 0, y: 0, z: 0 }
  end

  def inp(register)
    @registers[register] = @input.shift
  end

  def translate_var(var)
    if var =~ /\d/
      var.to_s.to_i
    else
      @registers[var]
    end
  end

  def add(register, value)
    @registers[register] = @registers[register] + translate_var(value)
  end

  def mul(register, value)
    @registers[register] = @registers[register] * translate_var(value)
  end

  def div(register, value)
    @registers[register] = @registers[register] / translate_var(value)
  end

  def mod(register, value)
    @registers[register] = @registers[register] % translate_var(value)
  end

  def eql(register, value)
    @registers[register] = @registers[register] == translate_var(value) ? 1 : 0
  end

  def run!
    @program.each do |instruction|
      parts = instruction.split(/\s+/)

      if parts.first == "inp"
        inp(parts.last.to_sym)
      else
        self.send(*parts.map(&:to_sym))
      end
    end

    @registers
  end
end

# lmao I'm a compiler
# update: a very shitty one, fuck
class ModelNumberChecker
  def initialize(program)
    @registers = { w: 0, z: 0 }
    compile!(program)
  end

  def compile!(program)
    @constants = []

    14.times do
      program.shift 4
      divisor = program.shift.split(' ').last.to_i
      add = program.shift.split(' ').last.to_i
      program.shift 9
      add_2 = program.shift.split(' ').last.to_i
      program.shift 2

      @constants << {
        divisor: divisor,
        add: add,
        add_2: add_2
      }
    end
  end

  def valid?(input)
    z = 0

    input.digits.reverse.each_with_index do |digit, index|
      constants = @constants[index]


      if digit == (z % 26) + constants[:add]
        return false if constants[:add] < 0 

        z /= constants[:divisor]
      else
        z /= constants[:divisor]
        z *= 26
        z += digit + constants[:add_2]
      end
    end

    z.zero?
  end
end

if ARGV.empty?
  Day24.run 'input/day24.txt'
else
  Day24.run 'test/day24.txt'
end
