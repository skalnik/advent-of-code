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
    ractors = []
    20.times do
      ractors << Ractor.new(@input.dup) do |input|
        monad = ModelNumberChecker.new(input)

        while number = Ractor.receive
          puts "Checking #{number}"
          if monad.valid? number.digits
            puts "FOUND VALID NUMBER"
            Ractor.yield number
          end
        end
      end
    end

    99999999999999.downto(11111111111111).each do |model_number|
      next if model_number.digits.include? 0

      ractors[model_number % 10].send(model_number)
    end

    ractor, number = ractors.select(*ractors)

    return number
  end

  def part_two
  end
end

class Program
  attr_reader :registers

  def initialize(input, program)
    @input = input
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
      offset = program.shift.split(' ').last.to_i
      program.shift 9
      offset_2 = program.shift.split(' ').last.to_i
      program.shift 2

      @constants << {
        divisor: divisor,
        offset: offset,
        offset_2: offset_2
      }
    end
  end

  def valid?(input)
    @registers = { w: 0, z: 0 }

    input.each_with_index do |digit, index|
      constants = @constants[index]

      @registers[:w] = digit

      divided = @registers[:z] / constants[:divisor]
      if (@registers[:z] % 26 + constants[:offset]) == @registers[:w]
        @registers[:z] = divided
      else
        @registers[:z] = divided
        @registers[:z] *= 26
        @registers[:z] += @registers[:w] + constants[:offset_2]
      end
    end

    @registers[:z] == 0
  end
end

if ARGV.empty?
  Day24.run 'input/day24.txt'
else
  Day24.run 'test/day24.txt'
end
