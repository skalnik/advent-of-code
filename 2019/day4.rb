def has_double?(value)
  value = value.to_s

  value.chars.each_with_index do |digit, index|
    return false if index + 1  > value.length

    return true if digit == value[index + 1]
  end

  false
end

def no_decrease?(value)
  low = 0
  value.to_s.each_char do |digit|
    digit = digit.to_i
    return false if digit < low

    low = digit
  end

  true
end

def exactly_one_pair?(value)
  prev = ''
  consecutive = 0
  lengths = []

  value.to_s.each_char do |digit|
    if digit == prev
      consecutive += 1
    else
      lengths << consecutive
      consecutive = 1
    end

    prev = digit
  end
  lengths << consecutive

  lengths.include?(2)
end

valid_pws = []
(125730..579381).each do |pass|
  valid_pws << pass if has_double?(pass) && no_decrease?(pass)
end

puts "Part 1: #{valid_pws.count}"

extra_valid_pws = []
valid_pws.each do |pass|
  extra_valid_pws << pass if exactly_one_pair?(pass)
end

puts "Part 2: #{extra_valid_pws.count}"
