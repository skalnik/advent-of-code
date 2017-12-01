#!/usr/bin/env ruby


def sum_captcha(captcha)
  sum = 0
  captcha_chars = captcha.chars
  captcha_chars.each_with_index do |digit, index|
    next_index = (index + 1) % captcha_chars.length
    next_digit = captcha_chars[next_index]

    sum += digit.to_i if digit == next_digit
  end

  sum
end

puts sum_captcha ARGV[0]
