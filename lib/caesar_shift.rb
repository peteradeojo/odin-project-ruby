def caesar_shift(string, shift)
  for i in 0...string.length do
    code = string[i].ord

    (a, z) = case code
             when 97..122 then [97, 122]
             when 65..90 then [65, 90]
             else next
             end

    rotate = shift > 0 ? 26 : -26

    code += shift
    code -= rotate unless code.between?(a, z)

    string[i] = code.chr
  end

  string
end
