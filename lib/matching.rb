# Object Pattern Matching
input = 3

case input
in String then puts 'input was type String'
in Integer then puts 'input was an Integer'
end

# Variable pattern
a = 1
case 1
in ^a
  :no_match
end

# As pattern
case 3
in 3 => a
  puts a
end

# Alternative Pattern
case 0
in 0 | 1 | 2
  puts :match
end

# Guard conditions
some_val = true
case 0
in 0 if some_val
  puts :match
end

# Array pattern
arr = [1,2]
# arr = [3,4]
  # Value or type matching
case arr
in [Integer, Integer] then puts :match
in [String, String] then puts :no_match
end

  # Scoop variables
arr = [1, 2, 3, 5, 4]
case arr
in [Integer, Integer, *tail]
  p tail
end

  # with guards and ignoring
arr = [1,1,3,4]
case arr
in [a,b, *tail] if a === b
  puts :match
end

  # With As matching
arr = [1,2,3,[4,5]]

case arr
in [1,2,3, [4, a] => b]
  puts a
  p b
end

# Hash Pattern
puts "\nHash Pattern #1\n"
case {a: 'apple', b: 'banana'}
in {a: 'aardvark', b: 'bat'}
puts :no_match
in a:, b:
  # puts :match
  puts a
  puts b
end

puts "\nHash Pattern #2\n"
hash = { a: 'ant', b: 'ball', c: 'cat' }

case hash
in {a: 'ant', **rest}
  p rest
end

# Rightward Assignment
puts "\nRightward Assignment\n"
login = { username: 'hornby', password: 'iliketrains' }

login => { username: username }

puts "Logged in with username #{username}\n"

# Find Pattern
puts "\nFind Pattern #1\n"
case [0,6,1,2,3,4]
in [*pre, 1, 2, 3, *post]
  p pre
  p post
end

puts "\nFind Pattern #2"
case [1, 2, "a", 4, "b", "c", 7, 8, 9]
in [*pre, String => x, String => z, *post]
  p pre
  p x
  p z
  p post
end

puts "\nFind Pattern #3"
data = [
  {name: 'James', age: 50, first_language: 'english', job_title: 'general manager'},
  {name: 'Jill', age: 32, first_language: 'italian', job_title: 'leet coder'},
  {name: 'Helen', age: 24, first_language: 'dutch', job_title: 'biscuit quality control'},
  {name: 'Bob', age: 64, first_language: 'english', job_title: 'table tennis king'},
  {name: 'Betty', age: 55, first_language: 'spanish', job_title: 'pie maker'},
]

name = "Jill"
age = 32
job_title = 'leet coder'

case data
in [*, {name: ^name => name, first_language: first_language} => obj, *]
else
  first_language = nil
end
puts first_language