def possible(fields, tickets, index)
  possible = []
  fields.each { |k, v|
    if tickets.all? { |ticket|
         f = ticket[index]
         (f >= v[0][0] && f <= v[0][1]) || (f >= v[1][0] && f <= v[1][1])
       }
      possible << k
    end
  }
  possible
end

def run(f)
  data = File.read(f).lines(chomp: true)

  fields = Hash.new
  your = nil
  nearby = []
  data.each { |row|
    case row
    when /^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/
      fields[$1] = [[$2.to_i, $3.to_i], [$4.to_i, $5.to_i]]
    when /,/
      if your.nil?
        your = row
      else
        nearby << row
      end
    end
  }

  invalid = []
  nearby.each { |ticket|
    ts = ticket.split(',').map(&:to_i)
    ts.each { |t|
      if fields.values.all? { |v| (t < v[0][0] || t > v[0][1]) && (t < v[1][0] || t > v[1][1]) }
        invalid << t
      end
    }
  }

  valid = nearby.filter { |ticket|
    ts = ticket.split(',').map(&:to_i)
    inv = false
    ts.each { |t|
      if fields.values.all? { |v| (t < v[0][0] || t > v[0][1]) && (t < v[1][0] || t > v[1][1]) }
        inv = true
        break
      end
    }
    !inv
  }

  all_tickets = ([your] + valid).map { |ticket| ticket.split(',').map(&:to_i) }
  mappings = []
  (0...all_tickets[0].length).each { |i|
    mappings << possible(fields, all_tickets, i)
  }
    
  while mappings.any? { |mapping| mapping.length > 1 }
    determined = mappings.filter{ |mapping| mapping.length == 1}.flatten
    mappings = mappings.map { |mapping| mapping.length > 1 ? (mapping - determined) : mapping }
  end

  departure_mappings = mappings.flatten.map.with_index { |m, i| i if m.start_with? 'departure' }.compact
  your_fields = your.split(',').map(&:to_i)
  final = departure_mappings.map { |d| your_fields[d] }.reduce(:*)
  [ invalid.reduce(:+), final ]
end
