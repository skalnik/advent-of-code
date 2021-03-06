#!/usr/bin/env ruby

class Day1
  def self.run(input_file)
    captcha = File.read(input_file).chomp
    puts "Part 1: #{Day1.new(captcha).run(part: 1)}"
    puts "Part 2: #{Day1.new(captcha).run(part: 2)}"
  end

  def initialize(captcha)
    @captcha = captcha
  end

  def run(part: 1)
    sum = 0
    captcha_chars = @captcha.chars
    captcha_chars.each_with_index do |digit, index|
      next_index = -1
      if part == 1
        next_index = index_part_1(index, captcha_chars.length)
      else
        next_index = index_part_2(index, captcha_chars.length)
      end
      next_digit = captcha_chars[next_index]

      sum += digit.to_i if digit == next_digit
    end

    sum
  end

  def index_part_1(current_index, length)
    (current_index + 1) % length
  end

  def index_part_2(current_index, length)
    (current_index + (length / 2)) % length
  end
end

Day1.run 'input/day1.txt' if __FILE__ == $0
