#!/usr/bin/env ruby

class Day3
  class << self
    def run(input_file)
      number  = File.read(input_file).chomp.to_i
      size = Math.sqrt(number).ceil
      spiral = Array.new(size) { Array.new(size, nil) }

      current_val = size * size
      row, col, = 0, 0

      input_loc = [0, 0]

      dir = 0
      directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]

      while current_val > 1 do
        spiral[row][col] = current_val
        input_loc = [row, col] if current_val == number
        next_loc = [row + directions[dir][0], col + directions[dir][1]]

        if next_loc[0] >= spiral[row].size || next_loc[1] >= spiral.size ||
            next_loc[0] < 0 || next_loc[1] < 0 || spiral[next_loc[0]][next_loc[1]]
          dir = (dir + 1) % 4
        end

        current_val -= 1
        row += directions[dir][0]
        col += directions[dir][1]
      end

      puts input_loc.inspect
      puts (input_loc[0] - row).abs + (input_loc[1] - col).abs
    end
  end
end

Day3.run 'input/day3.txt' if __FILE__ == $0

