🎄 Advent of Code 🎄
====================

My solutions for Advent of Code.

Ruby Template
------------------

```ruby
#!/usr/bin/env ruby

class DayN
  def self.run(input_file)
    puts "Part 1: #{DayN.new(input_file).part_one}"
    puts "Part 2: #{DayN.new(input_file).part_two}"
  end

  def initialize(filename)
    @filename = filename
  end

  def part_one
    File.open(@filename) do |file|
    end
  end

  def part_two
  end
end

if ARGV.empty?
  DayN.run 'input/dayN.txt'
else
  DayN.run 'test/dayN.txt'
end
```
