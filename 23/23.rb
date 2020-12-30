Cup = Struct.new(:num, :next, :prev, keyword_init: true)

def printcups(current)
  cup = current
  c = Array.new
  f = true
  while f || cup != current
    f = false
    c << cup.num
    cup = cup.next
  end
  p c
end

def run(n = 100)
  input = '362981754'
  #input = '389125467'
  prev = nil
  first = nil
  nums = Array.new
  input.chars.each { |c|
    nums << c.to_i
    cup = Cup.new(num: c.to_i)
    cup.prev = prev if !prev.nil?
    first = cup if first.nil?
    prev = cup
  }
  first.prev = prev
  prev.next = first
  cup = prev
  while cup != first
    cup.prev.next = cup
    cup = cup.prev
  end
    

  mincup, maxcup = nums.minmax
  
  current = first
  printcups(current)
  n.times {
    extract = current.next
    extract_nums = [ current.next.num, current.next.next.num, current.next.next.next.num ]
    current.next = current.next.next.next.next
    current.next.prev = current
    dnum = current.num - 1
    if dnum < mincup then dnum = maxcup end
    while extract_nums.include? dnum
      dnum -= 1
      if dnum < mincup then dnum = maxcup end
    end
    destination = current
    while destination.num != dnum
      destination = destination.next
    end
    dnext = destination.next
    destination.next = extract
    extract.prev = destination
    extract.next.next.next = dnext
    dnext.prev = extract.next.next

    current = current.next
    printcups(current)
  }

  
  first
end

def run2(n = 10000000)
  cuph = Hash.new
  input = '362981754'
  #input = '389125467'
  prev = nil
  first = nil
  nums = Array.new
  input.chars.each { |c|
    nums << c.to_i
    cup = Cup.new(num: c.to_i)
    cuph[cup.num] = cup
    cup.prev = prev if !prev.nil?
    first = cup if first.nil?
    prev = cup
  }
  (nums.max + 1..1000000).each { |i|
    cup = Cup.new(num: i)
    cuph[cup.num] = cup
    cup.prev = prev
    prev = cup
  }
  first.prev = prev
  prev.next = first
  cup = prev
  while cup != first
    cup.prev.next = cup
    cup = cup.prev
  end
    
  mincup = nums.min
  maxcup = 1000000
  i = 0
  current = first
  n.times {
    i += 1
    if i % 100000 == 0
      puts i
    end
    
    extract = current.next
    extract_nums = [ current.next.num, current.next.next.num, current.next.next.next.num ]
    current.next = current.next.next.next.next
    current.next.prev = current
    dnum = current.num - 1
    if dnum < mincup then dnum = maxcup end
    while extract_nums.include? dnum
      dnum -= 1
      if dnum < mincup then dnum = maxcup end
    end
    destination = cuph[dnum]
    dnext = destination.next
    destination.next = extract
    extract.prev = destination
    extract.next.next.next = dnext
    dnext.prev = extract.next.next

    current = current.next
  }

  one = cuph[1]

  one.next.num * one.next.next.num
end
