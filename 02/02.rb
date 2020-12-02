def run(f)
  valid_sled_passwords = 0
  valid_toboggan_passwords = 0
  File.readlines(f).each do |line|
    line.strip!
    m = line.match(/(\d+)-(\d+) (\w): (\w+)/)
    a = m[1].to_i
    b = m[2].to_i
    letter = m[3]
    password = m[4]
    count = password.count(letter)
    valid_sled_passwords += 1 if count >= a && count <= b
    valid_toboggan_passwords += 1 if (password[a - 1] == letter) ^ (password[b - 1] == letter)
  end

  [ valid_sled_passwords, valid_toboggan_passwords ]
end
