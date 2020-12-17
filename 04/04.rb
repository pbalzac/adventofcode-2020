def check(fields)
  p fields
  other_fields = fields.keys - ['byr','iyr','eyr','hgt','hcl','ecl','pid','cid']
  if !other_fields.empty?
    p other_fields
  end
#  check_byr(fields) && check_iyr(fields) && check_eyr(fields) && check_hgt(fields) &&
#    check_hcl(fields) && check_ecl(fields) && check_pid(fields)
  
  x = fields.keys
  (x.include?('byr') && fields['byr'].to_i >= 1920 && fields['byr'].to_i <= 2002 && /[0-9]{4}/.match(fields['byr'])) &&
    (x.include?('iyr') && fields['iyr'].to_i >= 2010 && fields['iyr'].to_i <= 2020 && /[0-9]{4}/.match(fields['iyr'])) &&
    (x.include?('eyr') && fields['eyr'].to_i >= 2020 && fields['eyr'].to_i <= 2030 && /[0-9]{4}/.match(fields['eyr'])) &&
    (x.include?('hgt') && ((fields['hgt'].to_i >= 150 && fields['hgt'].to_i <= 193 && fields['hgt'][-2,2] == "cm") ||
                           (fields['hgt'].to_i >= 59 && fields['hgt'].to_i <= 76 && fields['hgt'][-2,2] == "in"))) &&
    (x.include?('hcl') && (/^#[a-f0-9]{6}$/.match(fields['hcl']))) &&
    check_ecl(fields) &&
#    (x.include?('ecl') && (/^(amb|blu|brn|gry|grn|hzl|oth)$/.match(fields['ecl']))) &&
    (x.include?('pid') && (/^[0-9]{9}$/.match(fields['pid'])))
end

def check_byr(fields)
  valid = !fields['byr'].nil? && fields['byr'].length == 4 && (1920..2002).include?(fields['byr'].to_i)
  puts fields['byr'] if !valid
  valid
end
def check_iyr(fields)
  valid = !fields['iyr'].nil? && fields['iyr'].length == 4 && (2010..2020).include?(fields['iyr'].to_i)
#  puts fields['iyr'] if !valid
  valid
end
def check_eyr(fields)
  valid = !fields['eyr'].nil? && fields['eyr'].length == 4 && (2020..2030).include?(fields['eyr'].to_i)
#  puts fields['eyr'] if !valid
  valid
end
def check_hgt(fields)
  valid = false
  if !fields['hgt'].nil?
    case fields['hgt']
    when /([0-9]+)in/
      valid = (59..76).include?($1.to_i)
    when /([0-9]+)cm/
      valid = (150..193).include?($1.to_i)
    else
#      puts fields['hgt']
    end
  else
 #   puts "empty hgt"
  end
  valid
end
def check_hcl(fields)
  valid = false
  if !fields['hcl'].nil?
    case fields['hcl']
    when /^#[0-9a-f]{6}$/
      valid = true
    else
 #     puts fields['hcl']
    end
  else
#    puts "empty hcl"
  end
  valid
end
def check_ecl(fields)
  valid = false
  if !fields['ecl'].nil?
    valid = %w(amb blu brn gry grn hzl oth).include?(fields['ecl'])
  else
 #   puts "empty ecl"
  end
  valid
end
def check_pid(fields)
  valid = false
  if !fields['pid'].nil?
    case fields['pid']
    when /^[0-9]{9}$/
      valid = true
    else
      puts fields['pid']
    end
  else
    puts "mept pid"
  end
  valid
end
def run(f)
  rows = File.read(f).lines(chomp: true)

  fields = Hash.new
  valid = 0
  passports = 0
  ecls = Set.new
  rows.each do |row|
    if row.empty?
      passports += 1 if !fields.empty?
      valid += 1 if check(fields)
      fields = Hash.new
    else
      entries = row.split(' ')
      entries.each do |entry|
        a = entry.split(':')
        fields[a[0]] = a[1]
        if a[0] == "ecl"
          ecls << a[1]
        end
      end
    end
  end
  puts valid
  valid += 1 if check(fields) && !rows[-1].empty?
  [valid, passports]
end
