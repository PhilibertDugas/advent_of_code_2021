require 'pry'

class Submarine
  def initialize(depth, horizontal_position)
    @depth = depth
    @horizontal_position = horizontal_position
  end

  def forward(units)
    @horizontal_position += units
  end

  def down(units)
    @depth += units
  end

  def up(units)
    @depth -= units
  end

  def multiplied_position
    @depth * @horizontal_position
  end
end

class ComplicatedSubmarine
  def initialize(depth, horizontal_position, aim)
    @depth = depth
    @horizontal_position = horizontal_position
    @aim = aim
  end

  def forward(units)
    @horizontal_position += units
    @depth += @aim * units
  end

  def down(units)
    @aim += units
  end

  def up(units)
    @aim -= units
  end

  def multiplied_position
    @depth * @horizontal_position
  end
end

def part_one
  submarine = Submarine.new(0, 0)
  commands = File.readlines('part1.txt')
  execute_commands(commands, submarine)

  puts submarine.multiplied_position
end

def part_two
  submarine = ComplicatedSubmarine.new(0, 0, 0)
  commands = File.readlines('part2.txt')
  execute_commands(commands, submarine)

  puts submarine.multiplied_position
end

def execute_commands(commands, submarine)
  commands.each do |command|
    instruction, units = command.split(' ')
    units = units.to_i
    case instruction
    when 'forward'
      submarine.forward(units)
    when 'down'
      submarine.down(units)
    when 'up'
      submarine.up(units)
    end
  end
end

puts part_one
puts part_two
