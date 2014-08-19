def fibonacci_num(limit)
    current = 0
    prev1, prev2 = 1, 1
    counter = 1
    sum = 0
    while counter<=limit do
      #sum += current
      prev1 =prev2
      prev2 = current
      sum += prev1 + prev2
      current = prev1 + prev2   
      counter +=1
    end
    puts "fibonacci #{current}"
    puts "sum #{sum}"
end

fibonacci_num(256)



