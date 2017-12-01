#!/usr/bin/env ruby


def sum_captcha(captcha)
  sum = 0
  captcha_chars = captcha.chars
  captcha_chars.each_with_index do |digit, index|
    digit = digit.to_i
    next_digit = -1
    if index + 1 < captcha_chars.length
      next_digit = captcha_chars[index + 1].to_i
    else
      next_digit = captcha_chars[0].to_i
    end

    sum += digit if digit == next_digit
  end

  sum
end

puts sum_captcha ARGV[0]
