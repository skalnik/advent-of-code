#!/usr/bin/env ruby

class Day4
  def self.run(input_file)
    correct_passphrases = 0
    File.open(input_file).each_line do |passphrase|
      correct_passphrases += 1 if valid_passphrase(passphrase)
    end
    puts correct_passphrases
  end

  def self.valid_passphrase(passphrase)
    passwords = passphrase.split(' ')
    #passwords.uniq == passwords

    passwords.map! { |word| word.chars.sort.join('') }

    passwords.uniq.size == passphrase.split(' ').size
  end
end

Day4.run 'input/day4.txt' if __FILE__ == $0
