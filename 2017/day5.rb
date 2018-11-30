#!/usr/bin/env ruby

class Day5
  def self.run(input_file)
    maze = []
    File.open(input_file).each_line { |offset| maze << offset.to_i }

    puts "Part 1: #{Day5.new(maze).run(part: 1)}"
    puts "Part 2: #{Day5.new(maze).run(part: 2)}"
  end

  def initialize(maze)
    @maze = maze
  end

  def run(part:)
    maze = @maze.clone

    out_of_maze = false
    current_index = 0
    step_count = 0
    while !out_of_maze do
      next_index = current_index + maze[current_index]

      if maze[current_index] >= 3 && part != 1
        maze[current_index] -= 1
      else
        maze[current_index] += 1
      end
      step_count += 1

      out_of_maze = true if next_index >= maze.size || next_index < 0

      current_index = next_index
    end

    step_count
  end
end

Day5.run 'input/day5.txt' if __FILE__ == $0
