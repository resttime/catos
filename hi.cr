class Greeter
  def initialize(name : String?)
    @name = name
  end
  def greet
    puts "Hello #{@name}!"
  end
end

puts "What is your name?"
input = gets
g = Greeter.new(input)
g.greet
