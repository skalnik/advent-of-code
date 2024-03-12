🎄 Advent of Code 🎄
====================

My solutions for Advent of Code.

Ruby Template
------------------

```ruby
#!/usr/bin/env ruby

class DayN
  def self.run(input_file)
    runner = DayN.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)
  end

  def part_one
    @input
  end

  def part_two
  end
end

if __FILE__ == $0
  if ARGV.empty?
    DayN.run 'input/dayN.txt'
  else
    DayN.run ARGV.first
  end
end
```
