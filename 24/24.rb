Coords = Struct.new(:x, :y)
class Coords
  def <=>(other)
    x == other.x ? y <=> other.y : x <=> other.x
  end
end

def adjacent(tile)
  x = tile.x
  y = tile.y
  [ Coords.new(x - 2, y), Coords.new(x + 2, y), Coords.new(x - 1, y - 1),
    Coords.new(x - 1, y + 1), Coords.new(x + 1, y - 1), Coords.new(x + 1, y + 1) ]
end

def count_adjacent(tiles, tile, color)
  adjacent(tile).map { |t| tiles[t] }.count(color)
end

def run(f, n = 100)

  tiles = Hash.new { |h, k| h[k] = :white }
  File.read(f).lines(chomp: true).each { |line|
    dirs = []
    i = 0
    while i < line.length
      if line[i] == 'n' || line[i] == 's'
        dirs << line[i, 2].to_sym
        i += 2
      else
        dirs << line[i].to_sym
        i += 1
      end
    end

    coords = Coords.new(0, 0)
    dirs.each { |dir|
      case dir
      when :w
        coords.x -= 2
      when :nw
        coords.x -= 1
        coords.y += 1
      when :ne
        coords.x += 1
        coords.y += 1
      when :e
        coords.x += 2
      when :se
        coords.x += 1
        coords.y -= 1
      when :sw
        coords.x -= 1
        coords.y -= 1
      end
    }

    if tiles[coords].nil?
      tiles[coords] = :black
    else
      tiles[coords] = tiles[coords] == :black ? :white : :black
    end
  }
  
  original_black = tiles.values.count(:black)

  n.times {
    next_tiles = Hash.new { |h, k| h[k] = :white }

    black_mappings = tiles.select { |k, v| v == :black }
    black_tiles = black_mappings.keys
    black_mappings.each { |k, v|
      c = count_adjacent(tiles, k, :black)
      if c == 0 || c >  2
        black_tiles -= [k]
      end
    }

    x_range = tiles.keys.map(&:x).minmax
    y_range = tiles.keys.map(&:y).minmax
    (x_range[0] - 1..x_range[1] + 1).each { |x|
      (y_range[0] - 1..y_range[1] + 1).each { |y|
        coords = Coords.new(x, y)
        if tiles[coords] == :white
          c = count_adjacent(tiles, coords, :black)
          black_tiles << coords if c == 2
        end
      }
    }

    black_tiles.each { |k|
      next_tiles[k] = :black
    }
    tiles = next_tiles
  }



  [ original_black, tiles.values.count(:black) ]
end
