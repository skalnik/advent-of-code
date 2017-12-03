#!/usr/bin/env ruby

class Day3
  class << self
    def run(input_file)
      number  = File.read(input_file).chomp.to_i
      size = Math.sqrt(number).ceil
      spiral = Array.new(size) { Array.new(size, nil) }

      current_val = size * size
      row, col, = 0, 0
      current_dir = :right

      input_loc = [0, 0]

      while current_val > 1 do
        case current_dir
        when :right
          loop do
            spiral[row][col] = current_val
            input_loc = [row, col] if current_val == number

            break if col + 1 >= spiral[row].size || spiral[row][col + 1]

            current_val -= 1
            col += 1
          end
          current_dir = :down
        when :down
          loop do
            spiral[row][col] = current_val

            input_loc = [row, col] if current_val == number
            break if row + 1 >= spiral.size || spiral[row + 1][col]

            current_val -= 1
            row += 1
          end
          current_dir = :left
        when :left
          loop do
            spiral[row][col] = current_val

            input_loc = [row, col] if current_val == number
            break if col <= 0 || spiral[row][col - 1]

            current_val -= 1
            col -= 1
          end
          current_dir = :up
        when :up
          loop do
            spiral[row][col] = current_val

            input_loc = [row, col] if current_val == number
            break if row <= 0 || spiral[row - 1][col]

            current_val -= 1
            row -= 1
          end
          current_dir = :right
        end
      end

      puts input_loc.inspect
      puts (input_loc[0] - row).abs + (input_loc[1] - col).abs
    end
  end
end

Day3.run 'input/day3.txt' if __FILE__ == $0

