def get(data, x, y)
  return '' if y < 0 || y >= data.length || x < 0 || x >= data[y].length
  data[y][x]
end

def print_grid(grid)
  grid.each { |row|
    puts row
  }
  puts
end
  
def next_state(data, x, y)
  occupied = [ [y - 1, x - 1], [y - 1, x], [y - 1, x + 1], [y, x - 1], [y, x + 1],
               [y + 1, x - 1], [y + 1, x], [y + 1, x + 1] ].filter { |y, x| get(data, x, y) == '#' }.size
  seat = data[y][x]
  if seat == 'L' && occupied == 0
    '#'
  elsif seat == '#' && occupied >= 4
    'L'
  else
    seat
  end
end

def directional(data, x, y)
  width = data[y].length
  height = data.length
  
  result = []

  yy = y - 1
  yy -= 1 until yy < 0 || data[yy][x] != '.'
  result << ((yy < 0) ? '' : data[yy][x])
  
  yy = y + 1
  yy += 1 until yy >= height || data[yy][x] != '.'
  result << ((yy >= height) ? '' : data[yy][x])

  xx = x - 1
  xx -= 1 until xx < 0 || data[y][xx] != '.'
  result << ((xx < 0) ? '' : data[y][xx])

  xx = x + 1
  xx += 1 until xx >= width || data[y][xx] != '.'
  result << ((xx >= width) ? '' : data[y][xx])

  xx = x - 1
  yy = y - 1
  until xx < 0 || yy < 0 || data[yy][xx] != '.'
    xx -= 1
    yy -= 1
  end
  result << ((xx < 0 || yy < 0) ? '' : data[yy][xx])

  xx = x + 1
  yy = y + 1
  until xx >= width || yy >= height || data[yy][xx] != '.'
    xx += 1
    yy += 1
  end
  result << ((xx >= width || yy >= height) ? '' : data[yy][xx])

  xx = x - 1
  yy = y + 1
  until xx < 0 || yy >= height || data[yy][xx] != '.'
    xx -= 1
    yy += 1
  end
  result << ((xx < 0 || yy >= height) ? '' : data[yy][xx])

  xx = x + 1
  yy = y - 1
  until xx >= width || yy < 0 || data[yy][xx] != '.'
    xx += 1
    yy -= 1
  end
  result << ((xx >= width || yy < 0) ? '' : data[yy][xx])

  result
end

def next_state2(data, x, y)
  occupied = directional(data, x, y).count('#')
  seat = data[y][x]
  if seat == 'L' && occupied == 0
    '#'
  elsif seat == '#' && occupied >= 5
    'L'
  else
    seat
  end
end

def run(f)
  original = File.read(f).lines(chomp: true)
  results = []
  
  data = original.map(&:clone)
  prev_data = nil
  while data != prev_data do
    prev_data = data.map(&:clone)
    (0...data.length).each { |y|
      (0...data[y].length).each { |x|
        data[y][x] = next_state(prev_data, x, y)
      }
    }
  end
  results << data.map{ |row| row.count('#') }.reduce(:+)

  data = original.map(&:clone)
  prev_data = nil
  while data != prev_data do
    prev_data = data.map(&:clone)
    (0...data.length).each { |y|
      (0...data[y].length).each { |x|
        data[y][x] = next_state2(prev_data, x, y)
      }
    }
  end
  results << data.map{ |row| row.count('#') }.reduce(:+)

  results
end
