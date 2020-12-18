def perform(op, a, b)
  case op
  when :add
    return a + b
  when :multiply
    return a * b
  end
end

def run(f)
  data = File.read(f).lines(chomp: true)

  answers = []
  data.each { |row|
    tokens = row.split(' ')
    stack = [[]]
    tokens.each { |token|
      case token
      when /^(\d+)$/
        if stack[-1].empty?
          stack[-1] << $1.to_i
        else
          op = stack[-1].pop
          stack[-1] << perform(op, $1.to_i, stack[-1].pop)
        end
      when /^([+*])$/
        stack[-1] << ($1 == '+' ? :add : :multiply)
      when /^(\(+)(\d+)$/
        $1.length.times { stack << [] }
        stack[-1] << $2.to_i
      when /^(\d+)(\)+)$/
        op = stack[-1].pop
        stack[-1] << perform(op, $1.to_i, stack[-1].pop)
        $2.length.times {
          x = stack.pop
          num = x[0]
          if stack[-1].empty?
            stack[-1] << num
          else
            op = stack[-1].pop
            stack[-1] << perform(op, num, stack[-1].pop)
          end
        }
      end
    }
    answers << stack.pop.pop
  }

  [ answers.reduce(:+) ]
end
