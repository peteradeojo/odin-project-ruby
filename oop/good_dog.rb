module ToString
  def to_s
    "This is #{name}, a #{self.class}." + (age ? " It is #{age} years old" : '')
  end
end

class Animal
  attr_accessor :name

  DOG_YEARS = 7

  def initialize(name)
    @name = name
  end

  include ToString
end

class Dog < Animal
  attr_reader :age

  def initialize(name, age = nil)
    super(name)
    @age = (age * DOG_YEARS) if age
  end
end

class Poodle < Dog
end

class Cat
end

bruno = Poodle.new('Bruno')
puts ToString.to_s
