#!/usr/bin/env ruby

class Day7
  def self.run(input_file)
    runner = Day7.new(input_file)
    puts "Part 1: #{runner.part_one}"
    puts "Part 2: #{runner.part_two}"
  end

  def initialize(filename)
    input = File.readlines(filename, chomp: true)
    @file_tree = parse_tree(input)
  end

  def part_one
    matching_dirs = []
    @file_tree.each_entry do |entry|
      matching_dirs << entry if entry.is_a?(Directory) && entry.size < 100_000
    end

    matching_dirs.sum { |dir| dir.size }
  end

  def part_two
    total_space = 70_000_000
    update_size = 30_000_000

    unused_space = total_space - @file_tree.size

    needed_space = update_size - unused_space

    directories = []
    @file_tree.each_entry do |entry|
      directories << entry if entry.is_a? Directory
    end

    directories.sort! { |a, b| a.size <=> b.size }.find { |dir| dir.size > needed_space }.size
  end

  def parse_tree(input)
    root = Directory.new('/')
    current_dir = root
    input[2..input.size].each do |line|
      case line
      when '$ ls'
        next
      when '$ cd ..'
        current_dir = current_dir.parent
        next
      when /\$ cd (.+)/
        name = Regexp.last_match(1)
        unless (new_dir = current_dir.find_entry(name)) # lmao do we even need this
          new_dir = Directory.new(name, parent: current_dir)
          current_dir.entries << new_dir
        end
        current_dir = new_dir
      when /dir (.+)/
        current_dir.entries << Directory.new(Regexp.last_match(1), parent: current_dir)
      when /(\d+) (.+)/
        file = File.new(Regexp.last_match(2), Regexp.last_match(1).to_i)
        current_dir.entries << file
        current_dir.size += file.size
      else
        puts "Hit unexpected line: #{line}"
        exit
      end
    end

    root.recalculate_size!

    root
  end
end

class Directory
  attr_accessor :name, :entries, :size, :parent

  def initialize(name, parent: nil)
    @name = name
    @parent = parent
    @entries = []
    @size = -1
  end

  def find_entry(name)
    entries.find { |entry| entry.name == name }
  end

  def recalculate_size!
    @size = entries.sum do |entry|
      entry.recalculate_size! if entry.is_a? Directory

      entry.size
    end
  end

  def each_entry(&blk)
    entries.each do |entry|
      entry.each_entry(&blk) if entry.is_a? Directory
      blk.call(entry)
    end
  end

  def to_s
    "#{name}/ (#{size}): #{entries.size} entries"
  end
end

class File
  attr_accessor :name, :size
  
  def initialize(name, size)
    @name = name
    @size = size
  end

  def to_s
    "#{name} (#{size})"
  end
end

if ARGV.empty?
  Day7.run 'input/day7.txt'
else
  Day7.run 'test/day7.txt'
end
