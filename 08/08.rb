Instruction = Struct.new(:operation, :value)

$instructions = []
def execute(change_pc, new_operation)
  acc = 0
  pc = 0
  so_far = Set.new
  copied = Marshal.load( Marshal.dump($instructions))
  copied[change_pc].operation = new_operation
  while pc >= 0 && pc < copied.length
    instruction = copied[pc]
    offset = 1
    case instruction.operation
    when :nop
    when :acc
      acc += instruction.value
    when :jmp
      offset = instruction.value
    else
      puts "ERROR"
    end
    pc += offset
    return :halt if so_far.include? pc
    so_far << pc
  end
  acc
end

def halting_check()
  $instructions.each.with_index { |instr, i|
    if instr.operation == :nop || instr.operation == :jmp
      result = execute(i, instr.operation == :nop ? :jmp : :nop)
      puts result if result != :halt
    end
  }
  :error
end

def run(f)
  data = File.read(f).lines(chomp: true)

  data.each { |d|
    o, v = d.split(' ')
    $instructions << Instruction.new(o.to_sym, v.to_i)
  }
  nil
end
