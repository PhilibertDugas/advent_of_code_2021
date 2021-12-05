require 'pry'

def part_1
    readings = File.readlines('part1.txt')
    readings = readings.map(&:strip)

    gamma_string = ""
    element_by_position(readings).each do |_position, position_value|
        gamma_string << most_common_value_in_position(position_value)
    end
    epsilon_rate = gamma_string.split('').map { |char| char == "1" ? "0" : "1" }.join.to_i(2)
    gamma_rate = gamma_string.to_i(2)

    epsilon_rate * gamma_rate
end

def part_2
    readings = File.readlines('part2.txt')
    readings = readings.map(&:strip)

    oxygen_generator = most_common_readings(readings).first.to_i(2)
    scrubber_rating = least_common_readings(readings).first.to_i(2)
    oxygen_generator * scrubber_rating
end

def most_common_readings(readings, position = 0)
    return readings if readings.size == 1
    
    position_value = element_by_position(readings)[position]
    most_common = readings.reject { |reading| reading[position] != most_common_value_in_position(position_value) }
    return most_common_readings(most_common, position + 1)
end

def least_common_readings(readings, position = 0)
    return readings if readings.size == 1

    position_value = element_by_position(readings)[position]
    least_common = readings.reject { |reading| reading[position] == most_common_value_in_position(position_value) }
    return least_common_readings(least_common, position + 1)
end

def element_by_position(readings)
    element_by_position = {}
    readings.each do |reading|
        bits = reading.split('')
        bits.each_with_index do |value, index|
            if element_by_position[index].nil?
                element_by_position[index] = [value]
            else
                element_by_position[index] << value
            end
        end
    end
    element_by_position
end

def most_common_value_in_position(position_value)
    freq = position_value.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    
    return "1" if freq["0"] == freq["1"]
    position_value.max_by { |v| freq[v] }
end

pp "Part 1 #{part_1}"
pp "Part 2 #{part_2}"