# frozen-string-literal: true

# Game class
class Game
  attr_accessor :knight_loc, :board, :last_spot, :letter_to_num

  def initialize(knight_loc = [0, 0])
    self.knight_loc = knight_loc
    self.board = Array.new(8) { Array.new(8, ' ') }
    self.letter_to_num = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze
  end

  def show_board
    board.each_with_index do |row, index|
      row.each_with_index do |_space, index2|
        if index2 == 7
          puts board[index][index2]
        else
          print board[index][index2]
        end
      end
    end
  end

  def knight_moves
    # TODO
  end

  def make_board
    # ⬛ ⬜
    board.each_with_index do |row, index|
      row.each_with_index do |_space, index2|
        board[index][index2] = if index.even? && index2.even? || index.odd? && index2.odd?
                                 "\u2b1b".encode('utf-8') if board[index][index2] == ' '
                               else
                                 "\u2b1c".encode('utf-8') if board[index][index2] == ' '
                               end
      end
    end
  end

  def start_knight
    puts 'Where would you like to put the knight? (input a letter and number, e.g. a1, b4, e8, etc.)'
    selection = gets.chomp.split('')
    while (selection[0] =~ /[a-hA-H]/).nil? || (selection[1] =~ /[1-8]/).nil? || selection[1].to_i > 8
      puts 'Please select a valid spot to place your knight!'
      selection = gets.chomp.split('')
    end
    place_piece(selection)
  end

  def place_piece(selection)
    selection[0] = selection[0].downcase
    x_cord = letter_to_num[selection[0].to_sym]
    y_cord = selection[1].to_i
    board[x_cord][y_cord] = "\u265e "
  end
end

def start_game
  board = Game.new
  board.make_board
  board.show_board
  board.start_knight
  board.show_board
  # board.knight_moves

  # board.show_board

end

start_game
