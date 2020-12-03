def run(f)
  map = File.read(f).lines(chomp: true)

  trees_encountered = Array.new
  map_width = map[0].length
  [ [3, 1], [1, 1], [5, 1], [7, 1], [1, 2] ].each do | right, down |
    trees = x = 0
    (0...map.length).step(down) do |y|
      trees += 1 if map[y][x] == '#'
      x = (x + right) % map_width
    end
    trees_encountered << trees
  end

  [ trees_encountered[0], trees_encountered.reduce(:*) ]
end
