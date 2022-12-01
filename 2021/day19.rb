#!/usr/bin/env ruby

class Day19
  def self.run(input_file)
    runner = Day19.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    @scanners = []
    until input.empty?
      if input.shift =~ /--- scanner (\d+) ---/
        scanner = Scanner.new($1.to_i)
        @scanners << scanner

        input.take_while do |line|
          if line =~ /(-?\d+),(-?\d+),?(-?\d+)?/
            scanner.add_beacon(x: $1.to_i, y: $2.to_i, z: $3.to_i)
          end

          !line.empty?
        end
      end
    end
  end

  def part_one
    main_map = {}
    reference = @scanners.first

    @scanners[1..-1].each do |scanner|
      reference.each_beacon do |beacon|
        scanner.vectors_to_beacons_from(beacon).each do |vector|
          translated = scanner.translate_beacons(**vector)
          p translated
          if reference.overlapping_beacons(translated).size >= 3
            p vector
          end
        end
      end
    end


    #@scanners[1].each_beacon do |beacon|
    #  @scanners[0].vectors_to_beacons_from(beacon).each do |vector|
    #    translated = @scanners[1].translate_beacons(**vector)
    #    if @scanners[0].overlapping_beacons(translated).size >= 3
    #      return vector
    #    end
    #  end
    #end
  end

  def part_two
  end
end

class Scanner
  attr_reader :id, :beacons

  def initialize(id)
    @id = id
    @beacons = []
  end

  def add_beacon(x:, y:, z: 0)
    @beacons << Beacon.new(x: x, y: y, z: z)
  end

  def vectors_to_beacons_from(beacon)
    @beacons.map do |my_beacon|
      beacon.vector_to(my_beacon)
    end
  end

  def each_beacon
    @beacons.each do |beacon|
      yield beacon
    end
  end

  def translate_beacons(x:, y:, z:)
    scanner = Scanner.new(id: @id)
    self.each_beacon do |beacon|
      scanner.beacons << beacon.translate(x: x, y: y, z: z)
    end

    scanner
  end

  def include_beacon?(beacon)
    self.each_beacon do |my_beacon|
      return true if beacon == my_beacon
    end

    false
  end

  def overlapping_beacons(scanner)
    beacons = []
    scanner.each_beacon do |other_beacon|
      beacons << other_beacon if self.include_beacon? other_beacon
    end

    beacons
  end
end

class Beacon
  attr_reader :x, :y, :z

  def initialize(x:, y:, z:)
    @x, @y, @z = x, y, z
  end

  def translate(x: 0, y: 0, z: 0)
    Beacon.new(x: @x + x, y: @y + y, z: @z + z)
  end

  def vector_to(beacon)
    {
      x: beacon.x - @x,
      y: beacon.y - @y,
      z: beacon.z - @z,
    }
  end

  def ==(other)
    @x == other.x && @y == other.y && @z == other.z
  end
end

if ARGV.empty?
  Day19.run 'input/day19.txt'
else
  Day19.run 'test/day19.txt'
end
