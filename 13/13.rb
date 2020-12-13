def align_next(bus, time, increment)
  while (time + bus[1]) % bus[0] != 0
    time += increment
  end
  increment *= bus[0]
  [time, increment]
end

def run(f, start = 100000000000000)
  data = File.read(f).lines(chomp: true)

  timestamp = data[0].to_i
  buses = data[1].split(',')

  lowest = timestamp
  computation = 0
  buses.each { |bus|
    next if bus == 'x'
    bus = bus.to_i
    time = timestamp % bus
    wait = (time == 0) ? time : (bus - time)
    if wait < lowest
      computation = wait * bus
      lowest = wait
    end
  }

  buses = buses
    .map
    .with_index { |bus, i| [ bus, i] }
    .select{ |c| c[0] != 'x' }
    .map{ |c| [ c[0].to_i, c[1] ] }
    .sort_by { |c| c[0] }

  x = (start + buses[0][1]) / buses[0][0]
  time = (x * buses[0][0]) - buses[0][1]
  increment = buses[0][0]
  buses[1..-1].each { |bus|
    time, increment = align_next(bus, time, increment)
  }

  [ computation, time ]
end
