require 'set'
def run(f)
  groups = File.read(f).split("\n\n")
  any_answered_yes = 0
  groups.each do |group|
    any_answered_yes += group.split("\n").map{ |person| Set.new(person.chars) }.reduce(&:merge).size
  end

  all_answered_yes = 0
  groups.each do |group|
    all_answered_yes += group.split("\n").map{ |person| Set.new(person.chars) }.reduce(:&).size
  end
  [ any_answered_yes, all_answered_yes ]
end
