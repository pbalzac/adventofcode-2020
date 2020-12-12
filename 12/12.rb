def rotate(dir, amount, current_heading)
  new_heading = current_heading + (dir == :L ? -1 : 1) * amount
  new_heading += 360 if new_heading < 0
  new_heading % 360
end

$compass = { 0 => :E, 90 => :S, 180 => :W, 270 => :N }

def move(direction, amount, heading, coordinates)
  compass_heading = direction == :F ? $compass[heading] : direction
  
  case compass_heading
  when :E
    coordinates[0] = coordinates[0] + amount
  when :S
    coordinates[1] = coordinates[1] - amount
  when :W
    coordinates[0] = coordinates[0] - amount
  when :N
    coordinates[1] = coordinates[1] + amount
  end
end

def rotate_waypoint(dir, amount, waypoint)
  x, y = waypoint
  if amount == 180
    waypoint[0] = -1 * x
    waypoint[1] = -1 * y
  elsif dir == :L && amount == 90 || dir == :R && amount == 270
    waypoint[0] = -1 * y
    waypoint[1] = x
  else
    waypoint[0] = y
    waypoint[1] = -1 * x
  end
end

def move_waypoint(heading, amount, waypoint)
  case heading
  when :E
    waypoint[0] = waypoint[0] + amount
  when :S
    waypoint[1] = waypoint[1] - amount
  when :W
    waypoint[0] = waypoint[0] - amount
  when :N
    waypoint[1] = waypoint[1] + amount
  end
end

def move_ship_to_waypoint(amount, coordinates, waypoint)
  coordinates[0] = coordinates[0] + (amount * waypoint[0])
  coordinates[1] = coordinates[1] + (amount * waypoint[1])
end

def manhattan(coordinates)
  coordinates[0].abs + coordinates[1].abs
end

def run(f)
  directions = File.read(f).lines(chomp: true)

  heading = 0
  coordinates = [0, 0]
  directions.each { |d|
    instruction = d[0].to_sym
    amount = d[1..-1].to_i

    case instruction
    when :L, :R
      heading = rotate(instruction, amount, heading)
    else
      move(instruction, amount, heading, coordinates)
    end
  }

  ship = [0, 0]
  waypoint = [10, 1]

  directions.each { |d|
    instruction = d[0].to_sym
    amount = d[1..-1].to_i

    case instruction
    when :L, :R
      rotate_waypoint(instruction, amount, waypoint)
    when :F
      move_ship_to_waypoint(amount, ship, waypoint)
    else
      move_waypoint(instruction, amount, waypoint)
    end
  }
  
  [ manhattan(coordinates), manhattan(ship) ]
end
