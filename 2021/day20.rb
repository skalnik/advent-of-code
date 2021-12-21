#!/usr/bin/env ruby

class Day20
  def self.run(input_file)
    runner = Day20.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    algorithm = input.shift.chars.map { |c| c == "#" }
    input.shift # empty line
    @image = Image.new(data: input, algorithm: algorithm)
  end

  def part_one
    puts @image.value_of(x: 3, y: 0)
    puts @image.to_s
  end

  def part_two
  end

end

class Image
  def initialize(data: nil, image: nil, algorithm:)
    @image = Hash.new(false)
    @algorithm = algorithm

    if data
      data.each_with_index do |line, x|
        line.chars.each_with_index do |char, y|
          @image[[x, y]] = true if char == "#"
        end
      end
    elsif image
      @image = image
    end
  end

  def enhance_image
    new_image = Hash.new(false)
    max = max_dimensions

    (0..max[:x]).each do |x|
      (0..max[:y]).each do |y|
        value = self.value_of(x: x, y: y)
        new_image[[x, y]] = @algorithm[value]
      end
    end

    Image.new(image: new_image, algorithm: @algorithm)
  end

  def value_of(x:, y:)
    bit_count = 0
    binary = [
      { x: -1, y: -1 },
      { x: -1, y:  0 },
      { x: -1, y:  1 },
      { x:  0, y: -1 },
      { x:  0, y:  0 },
      { x:  0, y:  1 },
      { x:  1, y: -1 },
      { x:  1, y:  0 },
      { x:  1, y:  1 },
    ].map do |diff|
      nx = x + diff[:x]
      ny = y + diff[:y]

      print @image[[nx, ny]] ? "#" : "."
      bit_count += 1
      if bit_count % 3 == 0
        puts
      end

      @image[[nx, ny]] ? 1 : 0
    end.join

    puts binary

    binary.to_i(2)
  end

  def max_dimensions
    {
      x: @image.keys.map(&:first).max,
      y: @image.keys.map(&:last).max
    }
  end

  def to_s
    buffer = 0
    str = ""
    max = max_dimensions

    (-buffer..(max[:x] + buffer)).each do |x|
      (-buffer..(max[:y] + buffer)).each do |y|
        if @image[[x, y]]
          str << "#"
        else
           str << "."
        end
      end

      str << "\n"
    end

    str
  end
end

if ARGV.empty?
  Day20.run 'input/day20.txt'
else
  Day20.run 'test/day20.txt'
end

