#!/usr/bin/env ruby

class Day4
  def self.run(input_file)
    passphrases = []
    File.open(input_file).each_line { |line| passphrases << line.chomp }
    passphrases.compact!

    puts "Part 1: #{Day4.new(passphrases).run(part: 1)}"
    puts "Part 2: #{Day4.new(passphrases).run(part: 2)}"
  end

  def initialize(passphrases)
    @passphrases = passphrases
  end

  def run(part:)
    @passphrases.inject(0) do |sum, phrase|
      if part == 1
        sum += 1 if valid_passphrase_1(phrase)
      else
        sum += 1 if valid_passphrase_2(phrase)
      end

      sum
    end
  end

  def valid_passphrase_1(phrase)
    words = phrase.split(' ')
    words == words.uniq
  end

  def valid_passphrase_2(phrase)
    words = phrase.split(' ')
    valid_word_count = words.map { |word| word.chars.sort.join('') }.uniq.size

    valid_word_count == words.size
  end
end

Day4.run 'input/day4.txt' if __FILE__ == $0
