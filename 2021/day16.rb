#!/usr/bin/env ruby

class Day16
  def self.run(input_file)
    runner = Day16.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @input = File.readlines(filename, chomp: true)[0]
    bits = @input.chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0") }.join.chars
    @packet = Packet.new(bits)
  end

  def part_one
    @packet.version_sum
  end

  def part_two
    @packet.value
  end
end

class Packet
  @@TYPE_MAP = {
    -1 => :corrupt,
    0 => :sum,
    1 => :product,
    2 => :min,
    3 => :max,
    4 => :literal,
    5 => :gt,
    6 => :lt,
    7 => :eq
  }

  attr_reader :bits, :version, :length_type_id, :value, :subpackets, :version_sum

  def initialize(bits)
    @bits = bits
    @subpackets = []
    @version_sum = 0

    if @bits.size < 6
      @raw_type = -1
      return
    end

    @version = @bits.shift(3).join.to_i(2)
    @raw_type = @bits.shift(3).join.to_i(2)

    if operator?
      @length_type_id = @bits.shift.to_i

      process_subpackets
    end

    calculate_value
  end

  def type
    @@TYPE_MAP[@raw_type]
  end

  def operator?
    type != :corrupt && type != :literal
  end

  def literal?
    type == :literal
  end

  def process_subpackets
    return if type == :literal

    if @length_type_id == 0
      bit_length = @bits.shift(15).join.to_i(2)
      more_packet_bits = @bits.shift(bit_length)

      @subpackets << Packet.new(more_packet_bits)
      until @subpackets.last.bits.empty?
        @subpackets << Packet.new(@subpackets.last.bits)
      end
    else
      subpacket_count = @bits.shift(11).join.to_i(2)
      @subpackets << Packet.new(@bits)
      (subpacket_count - 1).times do
        @subpackets << Packet.new(@subpackets.last.bits)
      end
    end

    @version_sum = version
    @version_sum += @subpackets.map(&:version_sum).sum
  end

  def calculate_value
    values = @subpackets.map(&:value) unless @subpackets.empty?

    @value = case type
    when :literal
      value = []

      loop do
        next_bits = @bits.shift(5)
        start = next_bits.shift
        value << next_bits

        break if start.to_i == 0
      end

      value.flatten.join.to_i(2)
    when :sum
      values.sum
    when :product
      values.reduce(&:*)
    when :min
      values.min
    when :max
      values.max
    when :gt
      values[0] > values[1] ? 1 : 0
    when :lt
      values[0] < values[1] ? 1 : 0
    when :eq
      values[0] == values[1] ? 1 : 0
    end
  end

  def inspect
    str = "Packet:v.#{version}:t.#{type}:ltid.#{length_type_id}:val.#{value}"
    unless @subpackets.empty?
      str << ":subpackets.#{@subpackets.size}\n\t"
    end
    str << @subpackets.map { |s| s.inspect }.join("\n\t")

    str
  end
end

if ARGV.empty?
  Day16.run 'input/day16.txt'
else
  Day16.run 'test/day16.txt'
end
