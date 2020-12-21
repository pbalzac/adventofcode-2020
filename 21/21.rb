def run(f)
  allergens = Hash.new
  all_ingredients = Array.new
  File.read(f).lines(chomp: true).each { |line|
    m = line.match(/(?<ingredients>.*) \(contains (?<allergens>.*)\)/)
    ingredients = m[:ingredients].split(' ')
    all_ingredients += ingredients
    m[:allergens].split(',').map(&:strip).each { |allergen|
      if allergens[allergen].nil?
        allergens[allergen] = ingredients.to_set
      else
        allergens[allergen] = allergens[allergen] & ingredients.to_set
      end
    }
  }
  no_allergens = all_ingredients.to_set - allergens.values.reduce(:+)
  no_allergen_appearances = no_allergens.map { |a| all_ingredients.count(a) }.reduce(:+)

  until allergens.values.all? { |a| a.size == 1 }
    known = allergens.values.filter { |a| a.size == 1}.reduce(:+)
    allergens.each { |k, v|
      if v.size > 1
        allergens[k] = v - known
      end
    }
  end

  [ no_allergen_appearances, allergens.keys.sort.map { |k| allergens[k].to_a[0] }.join(',') ]
end
