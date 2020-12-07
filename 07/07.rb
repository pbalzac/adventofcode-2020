Bag = Struct.new(:modifier, :color)

def bag_contains_desired(bags, bag, desired)
  bags[bag].keys.any? { |inner| inner == desired || bag_contains_desired(bags, inner, desired) }
end

def size_of(bags, bag)
  bags[bag].empty? ? 0 : bags[bag].map { |k, v| v + (v * size_of(bags, k)) }.reduce(:+)
end

$shiny_gold = Bag.new(:shiny, :gold)

def run(f)
  data = File.read(f).lines(chomp: true)
  bag_definitions = Hash.new { |h, k| h[k] = Hash.new }
  data.each do |row|
    outer, inners = row.split(' contain ')
    outer_descriptor = outer.split(' ')
    outer_bag = Bag.new(outer_descriptor[0].to_sym, outer_descriptor[1].to_sym)
    inners.split(',').each do |inner|
      next if inner == 'no other bags.'
      inner_descriptor = inner.split(' ')
      inner_bag = Bag.new(inner_descriptor[1].to_sym, inner_descriptor[2].to_sym)
      bag_definitions[outer_bag][inner_bag] = inner_descriptor[0].to_i
    end
  end

  [ bag_definitions.keys.count { |bag| bag_contains_desired(bag_definitions, bag, $shiny_gold) },
    size_of(bag_definitions, $shiny_gold) ]
end
