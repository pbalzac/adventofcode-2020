def mask_it(mask, num)
  mask.each { |bit, val|
    if val == 0
      num = num & ~(1 << bit)
    else
      num = num | (1 << bit)
    end
  }
  num
end

def mask_two(mask, num, memory, address)
  mask.select { |bit, val| val == '1' }.keys.each { |bit|
    address = address | (1 << bit)
  }
  addresses = [ address ]
  mask.select { |bit, val| val == 'X' }.keys.each { |bit|
    next_expansion = []
    addresses.each { |addr|
      next_expansion << (addr & ~(1 << bit))
      next_expansion << (addr | (1 << bit))
    }
    addresses = next_expansion
  }
  addresses.each { |address|
    memory[address] = num
  }
end

def run(f)
  data = File.read(f).lines(chomp: true)

  memory = Hash.new(0)
  current_mask = 0
  data.each { |row|
    case row
    when /mask = (\w+)/
      current_mask = Hash.new(0)
      $1.chars.each.with_index { |c, i|
        next if c == 'X'
        current_mask[36 - (i + 1)] = c.to_i
      }
    when /mem\[(\d+)\] = (\d+)/
      memory[$1.to_i] = mask_it(current_mask, $2.to_i)
    end
  }
  sum = memory.values.reduce(:+)
  
  memory = Hash.new(0)
  data.each { |row|
    case row
    when /mask = (\w+)/
      current_mask = Hash.new(0)
      $1.chars.each.with_index { |c, i|
        current_mask[36 - (i + 1)] = c
      }
    when /mem\[(\d+)\] = (\d+)/
      mask_two(current_mask, $2.to_i, memory, $1.to_i)
    end
  }
  sum_two = memory.values.reduce(:+)  

  [ sum, sum_two ]
end
