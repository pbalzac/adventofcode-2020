def neighbors(grid, x, y, z)
  ns = []
  (z - 1..z + 1).each { |nz|
    (y - 1..y + 1).each { |ny|
      (x - 1..x + 1).each { |nx|
        if nx != x || ny != y || nz != z
          ns << grid[[nx, ny, nz]]
        end
      }
    }
  }
  ns
end

def fneighbors(grid, x, y, z, w)
  ns = []
  (w - 1..w + 1).each { |nw|
    (z - 1..z + 1).each { |nz|
      (y - 1..y + 1).each { |ny|
        (x - 1..x + 1).each { |nx|
          if nx != x || ny != y || nz != z || nw != w
            ns << grid[[nx, ny, nz, nw]]
          end
        }
      }
    }
  }
  ns
end

def run(f)
  data = File.read(f).lines(chomp: true)
  grid = Hash.new { |h, k| h[k] = :inactive }
  fgrid = Hash.new { |h, k| h[k] = :inactive }  
  
  data.each.with_index { |row, y|
    row.chars.each.with_index { |c, x|
      if c == '#'
        grid[[x, y, 0]] = :active
        fgrid[[x, y, 0, 0]] = :active
      end
    }
  }

  6.times do
    next_grid = Hash.new { |h, k| h[k] = :inactive }
    
    min_x, max_x = grid.keys.map { |k| k[0] }.minmax
    min_y, max_y = grid.keys.map { |k| k[1] }.minmax
    min_z, max_z = grid.keys.map { |k| k[2] }.minmax

    (min_z - 1..max_z + 1).each { |z|
      (min_y - 1..max_y + 1).each { |y|
        (min_x - 1..max_x + 1).each { |x|
          point = [x, y, z]
          active_neighbors = neighbors(grid, x, y, z).count(:active)
          status = grid[point]
          if status == :active && (active_neighbors == 2 || active_neighbors == 3)
            next_grid[point] = :active
          elsif status == :inactive && active_neighbors == 3
            next_grid[point] = :active
          end
        }
      }
    }

    grid = next_grid
  end

  6.times do
    next_fgrid = Hash.new { |h, k| h[k] = :inactive }
    
    min_x, max_x = fgrid.keys.map { |k| k[0] }.minmax
    min_y, max_y = fgrid.keys.map { |k| k[1] }.minmax
    min_z, max_z = fgrid.keys.map { |k| k[2] }.minmax
    min_w, max_w = fgrid.keys.map { |k| k[3] }.minmax

    (min_w - 1..max_w + 1).each { |w|
      (min_z - 1..max_z + 1).each { |z|
        (min_y - 1..max_y + 1).each { |y|
          (min_x - 1..max_x + 1).each { |x|
            point = [x, y, z, w]
            active_neighbors = fneighbors(fgrid, x, y, z, w).count(:active)
            status = fgrid[point]
            if status == :active && (active_neighbors == 2 || active_neighbors == 3)
              next_fgrid[point] = :active
            elsif status == :inactive && active_neighbors == 3
              next_fgrid[point] = :active
            end
          }
        }
      }
    }      

    fgrid = next_fgrid
  end
  
  [ grid.values.count(:active), fgrid.values.count(:active) ]
end
