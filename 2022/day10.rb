class Day10
  def self.run(input_file)
    runner = Day10.new(input_file)
    puts "Running CPU…"
    puts "Part 1 Sum: #{runner.part_one}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    cpu = CPU.new

    @input.each do |instruction|
      cpu.exec(instruction)
    end

    cpu.sum
  end
end

class CPU
  attr_reader :cycle, :x, :sum

  CHECK_AT = [20, 60, 100, 140, 180, 220].freeze

  def initialize
    @cycle = 0
    @x = 1
    @sum = 0
  end

  def noop
    increment_cycle
  end

  def addx(value)
    increment_cycle
    increment_cycle
    @x += value
  end

  def strength
    @cycle * @x
  end

  def increment_cycle
    str = ' '
    str = '█' if print_pixel?
    str << "\n" if position == 40
    print str

    @cycle += 1

    @sum += strength if CHECK_AT.include? @cycle
  end

  def exec(instruction)
    case instruction
    when 'noop'
      noop
    when /addx (.+)/
      value = Regexp.last_match(1).to_i
      addx(value)
    end
  end

  def print_pixel?
    sprite = [@x, @x + 1, @x + 2]
    sprite.include? position
  end

  def position
    (@cycle % 40) + 1
  end

  def to_s
    "Cycle: #{@cycle}. X: #{@x}"
  end
end

if ARGV.empty?
  Day10.run 'input/day10.txt'
else
  Day10.run 'test/day10.txt'
end
