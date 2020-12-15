def run(input, nth)
  spoken = Hash.new
  
  input[0..-2].each.with_index { |n, i|
    spoken[n] = i
  }
  last_spoken = input[-1]
  (input.length...nth).each { |i|
    this_spoken = 0
    if !spoken[last_spoken].nil?
      this_spoken = (i - 1) - spoken[last_spoken]
    end
    spoken[last_spoken] = i - 1
    last_spoken = this_spoken
  }
  last_spoken
end
