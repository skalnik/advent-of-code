#!/usr/bin/env ruby

class Day10
  def self.run(input_file)
    puts "Part 1: #{Day10.new(input_file).part_one}"
    puts "Part 2: #{Day10.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    File.open(@filename) do |file|
      file_lines = file.readlines(chomp: true)

      file_lines.map do |file_line|
        line = Line.new(file_line)
        next unless line.corrupt?

        line.score
      end.compact.sum
    end
  end

  def part_two
    File.open(@filename) do |file|
      file_lines = file.readlines(chomp: true)

      scores = file_lines.map do |file_line|
        line = Line.new(file_line)
        next unless line.incomplete?

        line.score
      end.compact.sort

      scores[scores.length / 2]
    end
  end
end

class Line
  OPENERS = "([{<".chars
  CLOSERS = ")]}>".chars

  attr_reader :incomplete, :corrupt, :corrupt_char, :line, :chars_left

  def initialize(line)
    @line = line
    @corrupt, @incomplete = false

    stack = []
    line.chars.each do |char|
      if OPENERS.include?(char)
        stack.push char
      else
        opener = stack.pop
        if OPENERS.index(opener) != CLOSERS.index(char)
          @corrupt = true
          @corrupt_char = char
          break
        end
      end
    end

    if !stack.empty? && !@corrupt
      @incomplete = true
      @chars_left = stack
    end
  end

  def corrupt?
    @corrupt
  end

  def incomplete?
    @incomplete
  end

  def score
    if corrupt?
      case @corrupt_char
      when ")"
        3
      when "]"
        57
      when "}"
        1197
      when ">"
        25137
      end
    elsif incomplete?
      score = 0
      @chars_left.reverse.each do |char|
        score *= 5
        char_score = OPENERS.index(char) + 1
        score += char_score
      end

      score
    end
  end
end

if ARGV.empty?
  Day10.run 'input/day10.txt'
else
  Day10.run 'test/day10.txt'
end
