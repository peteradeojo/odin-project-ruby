# How I Built a Command Line Gaming System in Ruby

- [How I Built a Command Line Gaming System in Ruby](#how-i-built-a-command-line-gaming-system-in-ruby)
  - [Introduction](#introduction)
  - [Defining our Objects](#defining-our-objects)

## Introduction
## Defining our Objects

Consider a Hangman game object implementation below

```rb
class Hangman

  def initialize
    # get the guessed word
    @word = get_random_word
    @turns = 10
    @guesses = Hangman.gather_guesses(@word)
  end

  def state
    @word.split('').reduce('') do |acc, letter|
      acc += (" #{letter} " if @guesses[letter]['guessed']) || ' _ '
      acc
    end
  end

  def play
    print "Enter a guess or 'save' to save the game [Guesses left: (#{turns})]: "
    letter = gets.chomp.strip
    
    if word_has_letter letter
      @guesses[letter]['guessed'] = true
    else
      @wrong_guesses << letter
      @turns -= 1
    end
  end

  def playable
    @turns > 0 && @guesses.keys.any? {|letter| @guesses[letter]['guessed'] == false}
  end

  private
  def self.gather_guesses(word)
    guesses = {}
    word.split('').each do |letter|
      unless guesses.keys.include? letter
        guesses[letter] = {'count' => 1, 'guessed' => false}
      else
        guesses[letter]['count'] += 1
      end
    end
    
    guesses
  end
  
  def word_has_letter(letter)
    @guesses.keys.include? letter
  end
end
```

The `Hangman` object has 4 public methods available : `initialize`, `state`, `play`, and `playable` and 2 private methods, 1 static method and 1 instance method : `gather_guesses`, which analyses the guess word data, and `word_has_letter` which checks if the letter supplied is contained in the guess word