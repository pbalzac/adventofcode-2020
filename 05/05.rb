Seat = Struct.new(:row, :col)
class Seat
  def id
    (row * 8) + col
  end
  def <=>(other)
    row == other.row ? col <=> other.col : row <=> other.row
  end
end

def getnum(code, low_value)
  v = 2 ** code.length
  range_start = 0
  range_end = v - 1
  code.chars.each do |c|
    v /= 2
    if c == low_value
      range_end -= v
    else
      range_start += v
    end
  end
  raise if range_start != range_end
  range_start
end

def get_seat(code)
  Seat.new(getnum(code[0, 7], 'F'), getnum(code[7, 3], 'L'))
end

def run(f)
  data = File.read(f).lines(chomp: true)

  highest = 0
  rows = Hash.new { |h, k| h[k] = [] }
  data.each do |datum|
    seat = get_seat(datum)
    rows[seat.row] << seat
    highest = [ highest, seat.id ].max
  end
  my_seat = nil
  sorted_rows = rows.keys.sort
  sorted_rows[1, sorted_rows.length - 2].each do |row|
    seat_numbers = rows[row].sort.map(&:col).sort
    missing = (seat_numbers.min..seat_numbers.max).to_a - seat_numbers
    if !missing.empty?
      my_seat = Seat.new(row, missing[0])
      break
    end
  end
  [highest, my_seat.id]
end
