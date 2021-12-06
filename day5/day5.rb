require 'pry'

class Grid
  def initialize(max_x, max_y)
    @rows = []
    max_y.times { @rows << GridRow.new(max_x) }
  end

  def apply_segment(segment)
    segment.vertical_range.each do |y_index, _index|
      grid_row = @rows[y_index]
      segment.horizontal_range.each { |position| grid_row.increment(position) }
    end
  end

  def apply_diagonal_segment(segment)
    segment.vertical_range.each_with_index do |y_index, index|
      grid_row = @rows[y_index]
      x_range = segment.horizontal_range
      grid_row.increment(x_range[index])
    end
  end

  def overlapping_point_count
    @rows.sum { |row| row.overlapping_point_count }
  end
end

class GridRow
  attr_reader(:points)

  def initialize(max_x)
    @points = Array.new(max_x, 0)
  end

  def increment(position)
    @points[position] += 1
  end

  def overlapping_point_count
    @points.count { |value| value > 1 }
  end
end

class Segment
  attr_reader(:starting, :ending)

  def initialize(starting, ending)
    @starting = starting
    @ending = ending
  end

  def horizontal_range
    if starting.first > ending.first
      (starting.first).downto(ending.first).to_a
    else
      (starting.first..@ending.first).to_a
    end
  end

  def vertical_range
    if starting.last > ending.last
      (starting.last).downto(ending.last).to_a
    else
      (starting.last..@ending.last).to_a
    end
  end

  def horizontal?
    @starting.first == @ending.first
  end

  def vertical?
    @starting.last == @ending.last
  end
end

def build_segments(filename)
  segments = []
  lines = File.readlines(filename)
  lines.each do |line|
    coordinates = line.split(' ').select { |entry| entry.include?(',') }
    coordinates = coordinates.map { |coordinate| coordinate.split(',').map(&:to_i) }
    segments << Segment.new(coordinates.first, coordinates.last)
  end
  segments
end

def build_grid(segments)
  max_x = segments.map { |segment| segment.horizontal_range }.flatten.max
  max_y = segments.map { |segment| segment.vertical_range }.flatten.max

  Grid.new(max_x + 1, max_y + 1)
end

def part_1
  segments = build_segments('part1.txt')

  grid = build_grid(segments)

  segments.reject! { |segment| !segment.horizontal? && !segment.vertical? }
  segments.each { |segment| grid.apply_segment(segment) }

  grid.overlapping_point_count
end

def part_2
  segments = build_segments('part2.txt')

  grid = build_grid(segments)

  straight_segments = segments.reject { |segment| !segment.horizontal? && !segment.vertical? }
  straight_segments.each { |segment| grid.apply_segment(segment) }

  diagonal_segments = segments.select { |segment| !segment.horizontal? && !segment.vertical? }
  diagonal_segments.each { |segment| grid.apply_diagonal_segment(segment) }

  grid.overlapping_point_count
end

pp part_1
pp part_2
