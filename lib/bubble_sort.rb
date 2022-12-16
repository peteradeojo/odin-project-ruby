def bubble_sort(array)
  array.each_with_index do
    array.each_with_index do |item, index|
      next unless index + 1 < array.length && (item >= array[index + 1])

      a = item
      b = array[index + 1]
      array[index] = b
      array[index + 1] = a
    end
  end
end

puts bubble_sort([24, 4, 3, 78, 2, 0, 2])
