#!/usr/bin/env ruby

def sum_captcha(captcha)
  sum = 0
  captcha_chars = captcha.chars
  captcha_chars.each_with_index do |digit, index|
    distance_away = index + (captcha_chars.length / 2)
    next_index = distance_away % captcha_chars.length
    next_digit = captcha_chars[next_index]

    sum += digit.to_i if digit == next_digit
  end

  sum
end

puts sum_captcha ARGV[0]
