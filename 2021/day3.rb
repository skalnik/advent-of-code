#!/usr/bin/env ruby

class Day3
  def self.run(input_file)
    puts "Part 1: #{Day3.new(input_file).part_one}"
    puts "Part 2: #{Day3.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    report = []
    File.open(@filename) do |file|
      report = file.readlines.map(&:strip)
    end
    gamma(report: report) * epsilon(report: report)
  end

  def gamma(report:)
    gamma = ""
    columns = report.map { |s| s.split(//) }.transpose

    columns.each do |col|
      gamma << most_common_bit(col)
    end

    gamma.to_i(2)
  end

  def epsilon(report:)
    epsilon  = ""
    columns = report.map { |s| s.split(//) }.transpose
    columns.each do |col|
      epsilon << least_common_bit(col)
    end

    epsilon.to_i(2)
  end

  def part_two
    report = []
    File.open(@filename) do |file|
      report = file.readlines.map(&:strip)
    end

    oxygen(report: report) * co2(report: report)
  end

  def oxygen(report:)
    values_left = report.dup
    current_column = 0
    while values_left.length > 1
      bits = values_left.map { |s| s.split(//) }.transpose[current_column]
      bit_criteria = most_common_bit(bits)
      values_left = values_left.select { |v| v[current_column] == bit_criteria }

      current_column += 1
    end

    values_left[0].to_i(2)
  end

  def co2(report:)
    values_left = report.dup
    current_column = 0
    while values_left.length > 1
      bits = values_left.map { |s| s.split(//) }.transpose[current_column]
      bit_criteria = least_common_bit(bits)
      values_left = values_left.select { |v| v[current_column] == bit_criteria }

      current_column += 1
    end

    values_left[0].to_i(2)
  end

  def most_common_bit(array)
    counts = array.group_by(&:itself).values.map(&:size)
    if counts[0] == counts[1]
      "1"
    else
      array.group_by(&:itself).values.max_by(&:size).first
    end
  end

  def least_common_bit(array)
    counts = array.group_by(&:itself).values.map(&:size)
    if counts[0] == counts[1]
      "0"
    else
      array.group_by(&:itself).values.min_by(&:size).first
    end
  end
end

Day3.run 'input/day3.txt' if __FILE__ == $0
