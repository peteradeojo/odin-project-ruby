def stock_picker(prices)
  days = []
  day = 0
  profit = 0

  prices.each_with_index do |price, index|
    prices.each_with_index do |future_price, j|
      next if j <= index

      if (future_price - price) > profit
        profit = future_price - price
        days[0] = index
        days[1] = j
      end
    end
  end

  (a,b) = days
end

puts stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])