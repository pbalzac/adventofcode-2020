require 'set'
def run(f)
  data = File.read(f).split("\n\n")
  yes_questions = 0
  data.each do |group|
    s = Set.new
    group.split("\n").each do |answers|
      s.merge(answers.chars)
    end
    yes_questions += s.size
  end

  all_answered_yes = 0
  data.each do |group|
    sets = []
    group.split("\n").each do |answers|
      sets << Set.new(answers.chars)
    end
    all_answered_yes += sets.reduce(:&).size
  end
  [ yes_questions, all_answered_yes ]
end
