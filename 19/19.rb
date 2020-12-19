Node = Struct.new(:subrules, :value, keyword_init: true)

def match(rules, rule_number, ss)
  ss.map{ |s|
    return_val = Array.new
    rule = rules[rule_number]
    if rule.subrules.nil?
      if s.start_with?(rule.value)
        return_val << s[rule.value.length..-1]
      end
    else
      return_val = rule.subrules.map { |sr|
        sr.reduce([s]) { |s, r| s.nil? ? nil : match(rules, r, s) }
      }.compact
    end
    return_val
  }.flatten
end

def run(f)
  rules = Hash.new
  tests = Array.new

  File.read(f).lines(chomp: true).each { |line|
    case line
    when /^(\d+): (.*)$/
      rule_id = $1.to_i
      rule = $2
      if rule =~ /"(.)"/
        rules[rule_id] = Node.new(value: $~[1])
      else
        subrules = rule.split('|').map{ |subrule| subrule.strip.split(' ').map(&:to_i) }
        rules[rule_id] = Node.new(subrules: subrules)
      end
    else
      tests << line if !line.length.zero?
    end
  }

  original_matches = tests.filter{ |s|
    test = match(rules, 0, [s])
    test.any? { |s| s.length.zero? }
  }
   
  rules[8] = Node.new(subrules: [ [42], [42, 8]])
  rules[11] = Node.new(subrules: [ [42, 31], [42, 11, 31] ])

  loop_matches = tests.filter{ |s|
    test = match(rules, 0, [s])
    test.any? { |s| s.length.zero? }
  }

  [ original_matches.length, loop_matches.length ]
  
end
