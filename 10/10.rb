$memo = Hash.new

def combinations(value, final, list)
  key = [ value, final, list ]
  return $memo[key] if !$memo[key].nil?

  final_reachable = (final - value) <= 3
  combos = final_reachable ? 1 : 0
  return combos if list.empty?
  
  next_adapters = list.filter { |n| n - value <= 3 }
  combos += next_adapters
              .map { |n| combinations(n, final, list.filter { |l| l > n }) }
              .reduce(:+)
  $memo[key] = combos
  combos
end

def run(f)
  adapters = File.read(f).lines(chomp: true).map(&:to_i).sort!

  differences = Hash.new(0)
  differences.merge! adapters
    .each_cons(2)
    .map { |a, b| b - a }
    .group_by(&:itself)
    .map { |k, v| [k, v.length] }
    .to_h
  differences[3] += 1 # add one difference of three for jumping to the device
  differences[adapters[0]] += 1 # and one difference from the outlet to the starting device
  device_joltage = adapters.max + 3

  [ differences[1] * differences[3], combinations(0, device_joltage, adapters) ]
end
