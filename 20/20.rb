def rotate(grid)
  (grid.length - 1..0).step(-1).map { |i|
    grid.map { |row| row[i] }.join
  }
end

def flip(grid)
  grid.map { |row| row.reverse }
end

def match(side, g1, g2)
  if side == :bottom
    return g1[-1] == g2[0]
  else
    return g1.map { |row| row[-1] } == g2.map { |row| row[0] }
  end
end

def match_line(tiles, l1, l2)
  (0...l1.length).all? { |n|
    match(:bottom, tiles[l1[n][0]][l1[n][1]], tiles[l2[n][0]][l2[n][1]])
  }
end

def get_line_tiles(l)
  l.map { |t| t[0] }
end

def printg(g)
  g.each { |row|
    puts row
  }
  puts
end

$dragon_coords =  [ [18, 0], [0, 1], [5, 1], [6, 1], [11, 1], [12, 1], [17, 1], [18, 1], [19, 1],
                    [1, 2], [4, 2], [7, 2], [10, 2], [13, 2], [16, 2] ]
$dragon_w = 20
$dragon_h = 3
def find_dragons(image)
  here_be_dragons = Array.new
  (0..image.length - $dragon_h).each { |y|
    (0..image[0].length - $dragon_w).each { |x|
      if $dragon_coords.all? { |cx, cy|
          image[cy + y][cx + x] == '#' }
        here_be_dragons << [x, y]
      end
    }
  }
  here_be_dragons
end

def replace_dragons(image, dragons)
  dragons.each { |x, y|
    $dragon_coords.each { |dx, dy|
      image[y + dy][x + dx] = 'O'
    }
  }
end

def turbulence(image)
  image.map{ |l| l.count('#') }.reduce(:+)
end

def all(grid)
  all = Array.new
  all << grid
  all << rotate(grid)
  all << rotate(rotate(grid))
  all << rotate(rotate(rotate(grid)))
  all += all.map { |g| flip(g) }
  all
end

def run(f)
  tiles = Hash.new { |h, k| h[k] = Array.new }

  current_tile = 0
  File.read(f).lines(chomp: true).each { |line|
    case line
    when /Tile (\d+):/
      current_tile = $1.to_i
      tiles[current_tile] = []
    else
      tiles[current_tile] << line if !line.length.zero?
    end
  }

  tiles.keys.each { |key|
    tiles[key] = all(tiles[key])
  }

  width = Integer.sqrt tiles.length
  pairs = []
  tiles.each { |n, grids|
    remaining = tiles.keys - [n]
    grids.each.with_index { |grid, i|
      remaining.each { |r|
        tiles[r].each.with_index { |nx, j|
          if match(:right, grid, nx)
            pairs << [[n, i], [r, j]]
          end
        }
      }
    }
  }

  lines = pairs.dup
  ll = 2
  while ll <= width - 2
    next_lines = []
    lines.each { |line|
      line_tiles = line.map { |t| t[0] }
      valid_next_pairs = pairs.filter{ |pair| (line_tiles & [ pair[0][0], pair[1][0] ]).empty? &&
                                       match(:right,
                                             tiles[line[-1][0]][line[-1][1]],
                                             tiles[pair[0][0]][pair[0][1]]) }
      valid_next_pairs.each { |p|
        next_lines << line + p
      }
    }
    lines = next_lines
    ll += 2
  end

  # handle odd width case

  line_pairs = []
  lines.each { |line|
    line_tiles = get_line_tiles(line)
    valid_next_lines = lines.filter { |l| (line_tiles & get_line_tiles(l)).empty? && match_line(tiles, line, l) }
    valid_next_lines.each { |l|
      line_pairs << [ line, l ]
    }
  }

  line_groups = line_pairs.dup
  ll = 2
  while ll <= width - 2
    next_line_groups = []
    line_groups.each { |lg|
      lg_tiles = lg.map { |l| get_line_tiles(l) }.flatten
      valid_next_lps = line_pairs.filter{ |lp| (lg_tiles & (get_line_tiles(lp[0]) + get_line_tiles(lp[1]))).empty? &&
                                       match_line(tiles, lg[-1], lp[0]) }
      valid_next_lps.each { |lp|
        next_line_groups << lg + lp
      }
    }
    line_groups = next_line_groups
    ll += 2
  end

  z = line_groups.map { |lg|
    [ lg[0][0][0], lg[0][-1][0], lg[-1][0][0], lg[-1][-1][0] ]
  }

  four_corners = z.map { |zz|
    zz.reduce(:*)
  }.uniq


  image = Array.new
  tile_size = tiles.values[0][0][0].length
  line_groups[0].each { |lg|
    (1...tile_size - 1).each { |i|
      image << lg.reduce('') { |a, t| a + tiles[t[0]][t[1]][i][1..-2] }
    }
  }

  rotations = all(image)

  final_image = nil
  dragons = nil
  rotations.each { |r|
    dragons = find_dragons(r)
    final_image = r
    break if !dragons.empty?
  }

  replace_dragons(final_image, dragons)

  printg(final_image)
  
  [ four_corners[0], turbulence(final_image) ]
end
