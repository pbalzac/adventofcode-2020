$nums = []

def run(f)
  File.readlines(f).each do |line|
    line.strip!
    $nums << line.to_i
  end

  product = 0
  (0...$nums.length).each do |i|
    (i...$nums.length).each do |j|
      (j...$nums.length).each do |k|
        if $nums[i] + $nums[j] + $nums[k] == 2020
          product = $nums[i] * $nums[j] * $nums[k]
        end
      end
    end
  end

  product
end
