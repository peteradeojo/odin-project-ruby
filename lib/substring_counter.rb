dictionary = %w[below down go going horn how howdy it i low own part partner sit]

def substrings(_word, subs)
  subs.reduce(Hash.new(0)) do |_acc, sub|
    _acc[sub] += 1 if _word.include?(sub)
    _acc
  end
end

puts substrings('below', dictionary)
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
