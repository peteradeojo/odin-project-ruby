def caesar_cipher(string, shift)
  letters = %w[a b c d e f g h i j k l m n o p q r s t u
               v w x y z]
  result = ''
  string.split('').map do |letter|
    if letters.include? letter.downcase
      lowercase = letter.downcase
      i = letters.index(lowercase) + shift
      i -= letters.length if i > letters.length - 1
      # puts "Index: #{letters.index(lowercase)} Shift: #{i}"

      result += if lowercase.eql?(letter)
                  letters[i]
                else
                  letters[i].upcase
                end
      # puts i
    else
      result += letter
    end
  end

  result
end
