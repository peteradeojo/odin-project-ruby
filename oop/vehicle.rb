module PetrolFuel
  def fuel
    self.fuel_tank_full = true
  end
end

class Vehicle
  attr_writer :year_bought

  @@number_of_cars = 0

  def initialize(year_bought)
    @year_bought = year_bought
    @@number_of_cars += 1
  end

  def total_vehicles
    @@number_of_cars
  end

  def age
    "This vehicle is #{calc_years} year(s) old"
  end

  private

  def calc_years
    t = Time.new(@year_bought)
    ((Time.now - t) / (60 * 60 * 24 * 365)).to_i
  end
end

class MyCar < Vehicle
  TYPE = 'Mercedes GT-x 350'

  include PetrolFuel
end

class MyTruck < Vehicle
  TYPE = 'Volvo A-3600'
end

frank = MyCar.new(2002)
puts frank.age
