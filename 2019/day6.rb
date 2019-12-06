def full_orbit(mass)
  if mass
    (full_orbit(@orbits[mass]) + [mass]).flatten
  else
    []
  end
end

@orbits = {}
File.new('input/day6.txt').each_line do |orbit|
  child, parent = orbit.chomp.split(')')
  @orbits[parent] = child
end

total_orbits = 0
@orbits.keys.each do |mass|
  total_orbits += (full_orbit(mass).length - 1)
end

puts "Part 1: #{total_orbits}"

you = full_orbit("YOU")
san = full_orbit("SAN")

transfers = ((you - san).length - 1) + ((san - you).length - 1)

puts "Part 2: #{transfers}"
