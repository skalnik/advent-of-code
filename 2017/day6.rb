#!/usr/bin/env ruby

class Day6
  def self.run(input_file)
    blocks = File.read(input_file).chomp
    blocks = blocks.split(/\s/)
    blocks.map! { |block| block.to_i }
    seen = [blocks.join('')]

    cycles = 0
    loop do
      to_reallocate = blocks.max
      current_index = blocks.find_index(to_reallocate)
      blocks[current_index] = 0

      while to_reallocate > 0 do
        current_index = (current_index + 1) % blocks.size
        blocks[current_index] += 1
        to_reallocate -= 1
      end
      cycles += 1
      break if seen.include?(blocks.join(''))

      seen << blocks.join('')
    end

    to_find = blocks.join('')
    size_of_loop = 0
    loop do
      to_reallocate = blocks.max
      current_index = blocks.find_index(to_reallocate)
      blocks[current_index] = 0

      while to_reallocate > 0 do
        current_index = (current_index + 1) % blocks.size
        blocks[current_index] += 1
        to_reallocate -= 1
      end
      size_of_loop += 1
      break if to_find == blocks.join('')
    end

    puts cycles
    puts size_of_loop
  end
end

Day6.run 'input/day6.txt' if __FILE__ == $0
