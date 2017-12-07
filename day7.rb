#!/usr/bin/env ruby

class Disc
  attr_accessor :name, :weight, :children, :balanced, :total_weight

  def initialize(name, weight, children)
    @name = name
    @weight = weight.to_i
    @children = children.nil? ? [] : children.split(', ')
    @balanced = nil
    @total_weight = -1
  end

  def to_s
    "#{name} (#{weight}) -> #{children.join(', ')}"
  end
end

class Day7
  def self.run(input_file)
    towers = {}
    File.open(input_file).each_line do |tower_description|
      definition = /(\w+)\s\((\d+)\)(\s->\s(.+))?/
      _, name, weight, _, children = *tower_description.match(definition)
      towers[name] = Disc.new(name, weight, children)
    end

    possible_roots = towers.keys
    towers.each do |name, disc|
      disc.children.each do |child|
        possible_roots.delete(child)
      end
    end

    root = possible_roots.shift

    calculate_balances(root, towers)

    unbalanced_discs = []
    towers.each do |name, tower|
      unbalanced_discs << tower unless tower.balanced
    end

    unbalanced_discs.sort! { |a, b| a.total_weight <=> b.total_weight }
    kid_weights = unbalanced_discs[0].children.inject([]) do |arr, child|
      arr << towers[child].total_weight
    end
    diff = kid_weights.max - kid_weights.min
    p unbalanced_discs[0]
  end

  def self.calculate_balances(root, towers)
    calculate_disc_weight(root, towers)

    disc = towers[root]
    kids = disc.children

    total_left = disc.total_weight - disc.weight
    kids_balanced = true
    if disc.balanced.nil? && kids.size > 0
      kids.each do |child|
        calculate_balances(child, towers)
        kids_balanced = kids_balanced && towers[child].balanced
        total_left -= towers[child].total_weight
      end

      disc.balanced = kids_balanced && total_left == 0
    else
      disc.balanced = true
    end
  end

  def self.calculate_disc_weight(name, towers)
    disc = towers[name]
    kid_value = -1
    if disc.children.size > 0
      disc.total_weight = disc.children.inject(disc.weight) do |sum, child|
        kid_weight = calculate_disc_weight(child, towers)
        kid_value = kid_weight if kid_value < 0
        disc.balanced = kid_value == kid_weight
        sum + kid_weight
      end
    else
      disc.balanced = true
      disc.total_weight = disc.weight
    end
  end
end

Day7.run 'input/day7.txt' if __FILE__ == $0
