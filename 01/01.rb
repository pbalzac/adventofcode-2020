def run(f)
  nums = []

  File.readlines(f).each do |line|
    line.strip!
    nums << line.to_i
  end

  product_of_two = 0
  product_of_three = 0
  (0...nums.length).each do |i|
    (i...nums.length).each do |j|
      product_of_two = nums[i] * nums[j] if nums[i] + nums[j] == 2020
      (j...nums.length).each do |k|
        product_of_three = nums[i] * nums[j] * nums[k] if nums[i] + nums[j] + nums[k]== 2020        
      end
    end
  end

  [ product_of_two, product_of_three ]
end
