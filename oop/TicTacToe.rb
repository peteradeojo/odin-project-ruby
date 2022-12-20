class Board
  attr_reader :players

  def initialize
    @state = Array.new(3) {Array.new(3)}
    @players = []
    @turn = false
    @done = false
    @winning_patterns = [
      [[0,0], [0,1], [0,2]],
      [[1,0], [1,1], [1,2]],
      [[2,0], [2,1], [2,2]],

      [[0,0], [1,0], [2,0]],
      [[0,1], [1,1], [2,1]],
      [[0,2], [1,2], [2,2]],

      [[0,0], [1,1], [2,2]],
      [[0,2], [1,1], [2,0]],
    ]
    @winner = nil
  end

  def add_player
    unless @players.length >= 2
      puts "Enter name for player #{@players.length + 1}"
      name = gets.chomp.strip
      puts "Select a playing character"
      character = gets.chomp.strip

      if (@players.any? {|player| player.character == character})
        puts "Character already selected"
        return false
      end

      player = Player.new name, character
      @players.push player

      true
    else
      false
    end

    false
  end

  protected
  def invert_turn
    @turn = !(@turn and true)
  end

  def parse_input(position)
    return if position > 9 or position < 1

    row = ((position - 1) / 3).to_i
    re_up = ->(n) { n == 0 ? n + 3 : n }
    column = re_up.call(position % 3) - 1

    [row, column]
  end

  public
  def state
    board = ""
    @state.each_with_index do |row, index|
      row.each_with_index do |cell, j|
        unless cell
          number = j + 1 + (3 * index)
          board += " #{number} "
        else
          board += " #{cell} "
        end
        (board += '|') if j + 1 < row.length
      end

      (board += "\n-----------\n") if index + 1 < @state.length
    end

    board
  end

  def play
    if @players.length < 2
      puts "Too few players. Please add another player"
      return
    end

    player = (@turn == false) ? @players[0]: @players[1]

    puts "\nPlayer " + (@turn == false ? "1" : "2") + ": select a slot to play"
    position = gets.chomp.strip.to_i
    
    if position.zero?
      return false
    end

    (row, column) = parse_input position
    # puts "\nRow: #{row} Column: #{column}"
    # puts "Value: " + (!@state[row][column].nil? ? @state[row][column] : "Nil")

    if @state[row][column].nil?
      @state[row][column] = player.character
    else
      return nil
    end

    if player.last_3_moves.length >= 3
      player.last_3_moves.shift
    end

    player.last_3_moves.push([row, column])
    puts state
    @winner = player if check_winner(player)

    invert_turn

    [row, column]
  end

  def status
    check_full_state = @state.all? do |n|
      n.all? {|i| !i.nil?}
    end

    if !check_full_state
      @done = false
      if !@winner.nil?
        @done = true
      end
    else
      @done = true
    end

    @done
  end

  def check_winner(player)
    plays =  player.last_3_moves.sort

    if @winning_patterns.include? plays
      return true
    end
    
    return false
  end

  def print_winner
    if !@winner.nil?
      return "The winner is " + @winner.name
    end

    "The game ended in a draw"
  end
end

class Player
  attr_reader :character, :name

  def initialize(name, character)
    @name = name
    @character = character
    @last_3_moves = []
  end

  def last_3_moves
    @last_3_moves
  end
end

board = Board.new

while board.players.length < 2
  board.add_player
end

puts board.state
puts
until board.status
  board.play
end

puts board.print_winner