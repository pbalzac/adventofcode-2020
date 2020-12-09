def run(f, slice)
  nums = File.read(f).lines(chomp: true).map(&:to_i)

  result = []
  previous = nums.slice(0, slice)
  (slice...nums.length).each { |n|
    number = nums[n]
    s = []
    previous.each { |p|
      break if s.include? p
      s << (number - p)
    }
    if s.size == slice
      result << number
      break
    end
    previous = previous.drop(1)
    previous << number
  }

  (0...nums.length - 2).each { |s|
    sum = nums[s]
    e = s
    while sum < result[0] && e < (nums.length - 1)
      e += 1
      sum += nums[e]
    end
    if sum == result[0]
      result << nums[s..e].min + nums[s..e].max
      break
    end
  }

  result
end
  

