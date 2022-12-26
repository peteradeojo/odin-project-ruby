# Polymorphism: A Game system in Ruby

- [Polymorphism: A Game system in Ruby](#polymorphism-a-game-system-in-ruby)
  - [What is Polymorphism?](#what-is-polymorphism)
  - [Why Polymorphism?](#why-polymorphism)

## What is Polymorphism?

Polymorphism is one of the core concepts of object-oriented programming (OOP) and describes situations in which something occurs in several different forms. In computer science, it describes the concept that you can access objects of different types through the same interface.

Simply put, different types of objects can be made to the same thing in different ways.

## Why Polymorphism?
Let's look at this example of input and output in Ruby to illustrate

```rb
> $stdout.puts "Hello world"
# Hello world
```

In the example about, `$stdout` is the computer's **standard output**. In most cases, this can be the console, or the screen. It represents a stream which the computer uses to display information to the standard output. Now let's take a look at writing to files.

```rb
> file = File.open('hello.txt', 'w')
> file.puts "Hello world"
```

We can see here that both the standard output `$stdout` and the `File` object implement the `puts` method. While the standard output displays the output to the user, the `File` object writes it to a file.

We see now how polymorphism allows us to implement objects that can be used in place of each other to perform similar actions, even though they might be performed differently.