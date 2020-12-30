def run(f)
  data = File.read(f).lines(chomp: true)

  card = data[0].to_i
  door = data[1].to_i

 # card = 5764801
 # door = 17807724

  v = 1
  loop = 0
  sn = 7
  while v != card
    v *= 7
    v = v % 20201227
    loop += 1
  end

  card_loop = loop

  v = 1
  loop = 0
  while v != door
    v *= 7
    v = v % 20201227
    loop += 1
  end

  door_loop = loop

  p [card_loop, door_loop]

  sn = card
  v = 1
  door_loop.times {
    v *= sn
    v = v % 20201227
  }
  ek1 = v

  sn = door
  v = 1
  card_loop.times {
    v *= sn
    v = v % 20201227
  }
  ek2 = v


  [ ek1, ek2 ]
end
