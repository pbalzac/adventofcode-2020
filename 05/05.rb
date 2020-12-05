Seat = Struct.new(:row, :col)
class Seat
  def id
    (row * 8) + col
  end
  def <=>(other)
    row == other.row ? col <=> other.col : row <=> other.row
  end
end

def getnum(code, low_value, high_value)
  code.gsub(low_value, '0').gsub(high_value, '1').to_i(2)
end

def get_seat(code)
  Seat.new(getnum(code[0, 7], 'F', 'B'), getnum(code[7, 3], 'L', 'R'))
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
