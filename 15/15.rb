def run(input, nth)
  spoken = Hash.new
  
  input.each.with_index { |n, i|
    spoken[n] = [ i + 1, -1 ]
  }
  last_spoken = input[-1]
  (input.length...nth).each { |i|
    this_spoken = 0
    if !spoken[last_spoken].nil? && spoken[last_spoken][1] != -1
      this_spoken = spoken[last_spoken][0] - spoken[last_spoken][1]
    end
    if spoken[this_spoken].nil?
      spoken[this_spoken] = [ i + 1, -1 ]
    else
      spoken[this_spoken][1] = spoken[this_spoken][0]
      spoken[this_spoken][0] = i + 1
    end
    last_spoken = this_spoken
  }
  last_spoken
end
