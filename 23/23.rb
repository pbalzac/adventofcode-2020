Cup = Struct.new(:num, :next, keyword_init: true)

def run
  input = '362981754'

  c1 = run_cups(input)
  c2 = run_cups(input, 10000000, 1000000)

  s = c1[1].next
  r = []
  until s.num == 1
    r << s.num
    s = s.next
  end

  [ r.join.to_i, c2[1].next.num * c2[1].next.next.num ]
end

def run_cups(input, moves = 100, cups_up_to = 0)
  first = prev = nil
  cups = Hash.new

  input.chars.each { |c|
    cup = Cup.new(num: c.to_i)
    cups[cup.num] = cup
    first = cup if first.nil?
    prev.next = cup if !prev.nil?
    prev = cup
  }

  (cups.keys.max + 1..cups_up_to).each { |i|
    cup = Cup.new(num: i)
    cups[cup.num] = cup
    prev.next = cup
    prev = cup
  }
  prev.next = first

  mincup, maxcup = cups.keys.minmax

  current = first
  moves.times {
    extract = current.next
    extract_nums = [ extract.num, extract.next.num, extract.next.next.num ]
    current.next = current.next.next.next.next
    dnum = current.num - 1
    dnum = maxcup if dnum < mincup
    while extract_nums.include? dnum
      dnum -= 1
      dnum = maxcup if dnum < mincup
    end
    destination = cups[dnum]
    dnext = destination.next
    destination.next = extract
    extract.next.next.next = dnext

    current = current.next
  }

  cups
end
