def run(f)
  groups = File.read(f).split("\n\n")

  any_answered_yes = 0
  all_answered_yes = 0

  groups.each do |group|
    answers = group.split("\n").map(&:chars)
    any_answered_yes += answers.reduce(:|).size
    all_answered_yes += answers.reduce(:&).size    
  end

  [ any_answered_yes, all_answered_yes ]
end
