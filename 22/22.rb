def recursive(deck1, deck2)
  previous_rounds = []
  infinite = false
  while !deck1.empty? && !deck2.empty?
    if previous_rounds.any? { |a, b| a == deck1 && b == deck2 }
      infinite = true
      break
    end

    previous_rounds << [ deck1.dup(), deck2.dup() ]
    
    c1 = deck1.shift
    c2 = deck2.shift

    if c1 > c2
      deck1 << c1 << c2
    else
      deck2 << c2 << c1
    end
  end

  return :player_one if infinite
  deck1.empty? ? :player_two : :player_one
end

def run(f)
  deck1 = []
  deck2 = []
  curr = deck1
  File.read(f).lines(chomp: true).each { |line|
    if line == 'Player 2:'
      curr = deck2
    end

    if line =~ /^\d+$/
      curr << line.to_i
    end
  }

  while !deck1.empty? && !deck2.empty?
    c1 = deck1.shift
    c2 = deck2.shift

    if c1 > c2
      deck1 << c1 << c2
    else
      deck2 << c2 << c1
    end
  end

  deck = deck1.empty? ? deck2 : deck1

  sum = 0
  (0...deck.length).each { |i|
    sum += (deck.length - i) * deck[i]
  }

  deck1 = []
  deck2 = []
  curr = deck1
  File.read(f).lines(chomp: true).each { |line|
    if line == 'Player 2:'
      curr = deck2
    end

    if line =~ /^\d+$/
      curr << line.to_i
    end
  }

  previous_rounds = []
  infinite = false
  while !deck1.empty? && !deck2.empty?
    p previous_rounds.size
    if previous_rounds.any? { |a, b| a == deck1 && b == deck2 }
      infinite = true
      break
    end
    
    previous_rounds << [ deck1.dup(), deck2.dup() ]
    
    c1 = deck1.shift
    c2 = deck2.shift

    if deck1.size >= c1 && deck2.size >= c2
      winner = recursive(deck1[0...c1].dup(), deck2[0...c2].dup())
      if winner == :player_one
        deck1 << c1 << c2
      else
        deck2 << c2 << c1
      end
    else
      if c1 > c2
        deck1 << c1 << c2
      else
        deck2 << c2 << c1
      end
    end
  end

  if infinite
    deck = deck1
  else
    deck = deck1.empty? ? deck2 : deck1
  end

  sum2 = 0
  (0...deck.length).each { |i|
    sum2 += (deck.length - i) * deck[i]
  }
  [ sum, sum2 ]
end
