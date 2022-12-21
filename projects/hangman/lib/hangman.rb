class Hangman
  attr_reader :word, :guesses, :turns

  def initialize
    File.open('google-10000-english-no-swears.txt') do |file|
      lines = file.readlines.select {|line| (line.length >= 5 and line.length <= 12)}

      @turns = 10
      @word = lines[rand(lines.length)].strip.upcase
    end

    @guesses = Hangman.gather_guesses @word
  end

  def state
    @word.split('').reduce('') do |acc, letter|
      acc += (" #{letter} " if @guesses[letter][:guessed]) || ' _ '
      acc
    end
  end

  def play(letter)
    letter.upcase!
    if word_has_letter letter
      @guesses[letter][:guessed] = true
    else
      @turns -= 1
    end
  end
  
  def playable
    @turns > 0 && @guesses.keys.any? {|letter| @guesses[letter][:guessed] == false}
  end

  def print_result
    unless playable
      if @guesses.keys.all? {|letter| @guesses[letter][:guessed] == true}
        puts
        puts state
        puts
        "You won. The word is #{word}"
      else
        "\nYou lost. The word was #{word}"
      end
    end
  end
  
  private
  def self.gather_guesses(word)
    guesses = {}
    word.split('').each do |letter|
      unless guesses.keys.include? letter
        guesses[letter] = {count: 1, guessed: false}
      else
        guesses[letter][:count] += 1
      end
    end
    
    guesses
  end
  
  def word_has_letter(letter)
    @guesses.keys.include? letter
  end
end

game = Hangman.new

while game.playable
  puts game.state
  print "Guess a letter: (#{game.turns} guess(es) left): "
  letter = gets.chomp.to_s.strip[0]
  game.play letter
end

puts game.print_result