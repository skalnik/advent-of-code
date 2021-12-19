#!/usr/bin/env ruby
require 'json'

class Day18
  def self.run(input_file)
    runner = Day18.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    @raw_numbers = File.readlines(filename, chomp: true).map { |l| JSON.parse(l) }
    @numbers = @raw_numbers.map { |array| SnailfishNumber.construct_tree(array) }
  end

  def part_one
    @numbers.inject do |tree, new_number|
      tree.add!(new_number)
    end.magnitude
  end

  def part_two
    magnitudes = []
    @raw_numbers.repeated_permutation(2) do |first, second|
      first_tree = SnailfishNumber.construct_tree(first)
      second_tree = SnailfishNumber.construct_tree(second)

      magnitudes << first_tree.add!(second_tree).magnitude
    end

    magnitudes.max
  end
end

class SnailfishNumber
  attr_accessor :left, :right, :parent, :value

  def initialize(left: nil, right: nil, value: nil, parent: nil)
    @left, @right = left, right
    @value = value
    @parent = parent
  end

  def leaf?
    !!@value
  end

  def node?
    !leaf?
  end

  def each_node
    @left&.each_node { |n| yield n }
    yield self
    @right&.each_node { |n| yield n }
  end

  def inspect
    str = []
    each_node do |node|
      str << "v:#{node.value};left:#{!node.left.nil?};right:#{!node.right.nil?}"
    end
    str.join("\n")
  end

  def add!(number)
    new_root = SnailfishNumber.new(left: self, right: number)
    self.parent = new_root
    number.parent = new_root

    new_root.reduce!

    new_root
  end

  def reduce!
    loop do
      if number = number_to_explode
        number.explode!
      elsif number = number_to_split
        number.split!
      else
        break
      end
    end
  end

  def number_to_explode(depth = 0)
    return self if depth >= 4 && node? && left.leaf? && right.leaf?
    left&.number_to_explode(depth + 1) || right&.number_to_explode(depth + 1)
  end

  def find_neighbor(direction)
    opposite = direction == :left ? :right : :left
    parent = self.parent
    child = self

    while parent
      directional = parent.send(direction)

      if directional != child
        node = parent.send(direction)
        node = node.send(opposite) while node.node?
        return node.leaf? ? node : nil
      end

      child = parent
      parent = parent.parent
    end
  end

  def explode!
    return if parent.nil? || left.node? || right.node?
    left_neighbor = find_neighbor(:left)
    right_neighbor = find_neighbor(:right)

    left_neighbor.value = left.value + left_neighbor.value if left_neighbor
    right_neighbor.value = right.value + right_neighbor.value if right_neighbor

    if parent.left == self
      self.parent.left = SnailfishNumber.new(value: 0, parent: parent)
    else
      self.parent.right = SnailfishNumber.new(value: 0, parent: parent)
    end
  end

  def number_to_split
    if leaf?
      return nil if value <= 9
      return self if value > 9
    end

    left&.number_to_split || right&.number_to_split
  end

  def split!
    return if node?

    self.left = SnailfishNumber.new(value: (value.to_f / 2).floor, parent: self)
    self.right = SnailfishNumber.new(value: (value.to_f / 2).ceil, parent: self)
    self.value = nil
  end

  def ==(other)
    return false if other.nil?
    left == other.left && right == other.right && value == other.value && parent.object_id == other.parent.object_id
  end

  def magnitude
    return value if leaf?

    return 3 * left.magnitude + 2 * right.magnitude
  end

  def self.construct_tree(value, parent = nil)
    return SnailfishNumber.new(value: value, parent: parent) unless value.is_a? Array

    node = SnailfishNumber.new(parent: parent)
    node.left = construct_tree(value.first, node)
    node.right = construct_tree(value.last, node)

    node
  end
end

if ARGV.empty?
  Day18.run 'input/day18.txt'
else
  Day18.run 'test/day18.txt'
end
