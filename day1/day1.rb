require 'pry'

def part_one
  values = File.readlines('part1.txt')
  count_increases(values.map(&:to_i))
end

def part_two
  values = File.readlines('part2.txt')
  window_sum = []
  values.each_cons(3) { |window| window_sum << window.map(&:to_i).sum }
  count_increases(window_sum)
end

def count_increases(values)
  counter = 0
  values.each_cons(2) do |first, second|
    counter += 1 if second > first
  end
  counter
end

puts part_two
