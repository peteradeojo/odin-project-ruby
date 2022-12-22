require 'json'
require 'time'

class GameLoader
  @@folder = '.saved/'

  def self.load_game(number)
    games = self.saved_game_files
    data = File.read(@@folder+games[number])

    data = JSON.parse(data)

    classname = Object.const_get(data['game'])
    classname.load_from_save_file(data['data'])
  end
  
  def self.saved_game_files
    Dir.mkdir @@folder unless Dir.exists? @@folder
    Dir.children(@@folder).select {|child| child.end_with? ".json"}
  end

  def self.list_saved_games
    files = self.saved_game_files
    
    files.each_with_index do |file, index|
      File.open(@@folder + file) do |file|
        data = JSON.load(file.read)
        puts "#{index + 1}: #{data['title']}"
      end
    end
  end

  def self.save_game_state(game)
    save_data = game.save
    
    File.open(@@folder + game.savefile + '.json', 'w') do |file|
      file.puts JSON.dump(save_data)
      puts "Game saved at #{game.savefile}"
    end
  end
end

class Game
  attr_reader :savefile

  def save
    classname = self.class.name
    date = Time.now
    filename = @savefile || "#{classname}-#{date.strftime("%Y-%m-%d-%k-%M")}".downcase
    data = serialize

    @savefile = filename

    save_data = {
      title: filename.capitalize,
      date: date.strftime("%Y-%m-%d %k:%M"),
      data: serialize,
      game: self.class
    }

    save_data
  end

  def self.load_from_save_file(data)
    self.load_save_state data
  end
end

class Hangman < Game
  attr_reader :word, :turns, :wrong_guesses, :unsaved

  def initialize(init_word = nil, init_turns = nil, init_guesses = nil, init_wrong_guesses=nil, init_savefile=nil)
    
    if init_word.nil?
      File.open('google-10000-english-no-swears.txt') do |file|
        lines = file.readlines.select {|line| (line.length >= 5 and line.length <= 12)}

        @word = lines[rand(lines.length)].strip.upcase
      end
    else
      @word = init_word
    end
    
    @turns = init_turns || 10
    @wrong_guesses = init_wrong_guesses || []
    @guesses = init_guesses ||( Hangman.gather_guesses @word)
    @savefile = init_savefile || nil
    @unsaved = true
  end

  def state
    @word.split('').reduce('') do |acc, letter|
      acc += (" #{letter} " if @guesses[letter]['guessed']) || ' _ '
      acc
    end
  end

  def play
    puts
    puts state
    print "Enter a guess or 'save' to save the game [Guesses left: (#{turns})]: "
    letter = gets.chomp.strip
    
    if letter.downcase == 'save'
      GameLoader.save_game_state self
      @unsaved = false
      return
    end

    letter = letter[0].upcase

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

  def print_result
    if @unsaved == false
      return "Your game has been saved"
    end

    unless playable
      if @guesses.keys.all? {|letter| @guesses[letter]['guessed'] == true}
        puts
        puts state
        puts
        "You won. The word is #{word}"
      else
        "\nYou lost. The word was #{word}"
      end
    end
  end

  def self.load_save_state(data)
    unserialize data
  end

  private
  attr_writer :word, :guesses, :turns, :wrong_guesses, :savefile

  def serialize
    data = {}
    instance_variables.each do |var|
      data[var] = instance_variable_get var
    end

    data
  end

  def self.unserialize(data)
    # data
    game = self.new data['@word'], data['@turns'], data['@guesses'], data['@wrong_guesses'], data['@savefile']
    game
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

game = nil

if GameLoader.saved_game_files.length > 0
  print "Do you want to load a saved game? (y/n): "
  print "\n"
  choice = gets.chomp.to_s

  if choice.downcase == 'y'
    GameLoader.list_saved_games
    print "Enter the number of the game to load: "
    number = gets.chomp.to_i - 1
    if number >= GameLoader.saved_game_files.length || number < 0
      puts "Invalid number selected."
    else
      game = GameLoader.load_game number
    end
  else
    game = Hangman.new
  end
else
  game = Hangman.new
end

while game.playable && game.unsaved
  game.play
end

puts game.print_result