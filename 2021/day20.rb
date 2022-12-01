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

    @image = Image.new(algorithm)

    input.each_with_index do |line, x|
      line.chars.each_with_index do |char, y|
        @image.mark_pixel(x, y) if char == "#"
      end
    end
  end

  def part_one
    puts @image
    puts enhanced = @image.enhance
    puts enhanced = enhanced.enhance
    enhanced.lit_pixels
  end

  def part_two
  end

end

class Image
  BUFFER = 2

  attr_reader :pixels, :algorithm

  def initialize(algorithm)
    @algorithm = algorithm

    @pixels = Hash.new(false)
  end

  def mark_pixel(x, y)
    @pixels[[x, y]] = true
  end

  def max
    [@pixels.keys.map(&:first).max, @pixels.keys.map(&:last).max]
  end

  def min
    [@pixels.keys.map(&:first).min, @pixels.keys.map(&:last).min]
  end

  def value_at(x, y)
    [
      [x - 1, y - 1],
      [x - 1, y    ],
      [x - 1, y + 1],
      [x    , y - 1],
      [x    , y    ],
      [x    , y + 1],
      [x + 1, y - 1],
      [x + 1, y    ],
      [x + 1, y + 1],
    ].map do |nx, ny|
      @pixels[[nx, ny]] ? "1" : "0"
    end.join.to_i(2)
  end

  def enhance
    max_x, max_y = max
    min_x, min_y = min
    new_image = Image.new(@algorithm)

    (min_x - BUFFER).upto(max_x + BUFFER).each do |x|
      (min_y - BUFFER).upto(max_y + BUFFER).each do |y|
        new_image.mark_pixel(x, y) if @algorithm[self.value_at(x, y)]
      end
    end

    new_image
  end

  def lit_pixels
    @pixels.values.count
  end

  def to_s
    str = ""
    max_x, max_y = max
    min_x, min_y = min

    (min_x - BUFFER).upto(max_x + BUFFER).each do |x|
      (min_y - BUFFER).upto(max_y + BUFFER).each do |y|
        if @pixels[[x, y]]
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

