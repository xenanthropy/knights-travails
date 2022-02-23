# frozen-string-literal: true

# Game class
class Game
  attr_accessor :knight_loc, :board, :current_spot, :last_spot, :letter_to_num

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
    y_cord = selection[1].to_i - 1
    board[x_cord][y_cord] = "\u265e "
    self.current_spot = [x_cord, y_cord]
    show_board
    puts 'Where would you like to move now?'
    selection = gets.chomp.split('')
    while (selection[0] =~ /[a-hA-H]/).nil? || (selection[1] =~ /[1-8]/).nil? || selection[1].to_i > 8
      puts 'Please select a valid spot to place your knight!'
      selection = gets.chomp.split('')
    end
    solution = knight_moves(selection)
    puts solution
    puts " It took #{solution[0]} moves!"
    puts "here's your path: "
    p calculate_path(solution[1])
  end

  def calculate_path(node)
    final_path = []

    until node.parent.nil?
      final_path.unshift([node.x_cord, node.y_cord])
      node = node.parent
    end
    final_path.unshift(current_spot)
    final_path
  end

  def knight_moves(dest, source = Node.new(current_spot[0], current_spot[1]))
    row = [2, 2, -2, -2, 1, 1, -1, -1].freeze
    col = [-1, 1, 1, -1, 2, -2, 2, -2].freeze
    dest = Node.new(letter_to_num[dest[0].to_sym], dest[1].to_i - 1)

    queue = []
    node = Node.new(current_spot[0], current_spot[1])
    queue.push(node)
    visited = []
    parent_node = ''
    until queue.empty?
      node = queue.shift
      parent_node = node
      node_x = node.x_cord
      node_y = node.y_cord
      dist = node.dist
      return [dist, node] if node_x == dest.x_cord && node_y == dest.y_cord

      next if visited.include?(node)

      visited.push(node)
      row.each_with_index do |_each, index|
        mod_x = node_x + row[index]
        mod_y = node_y + col[index]
        queue.push(Node.new(mod_x, mod_y, dist + 1, parent_node)) if valid_move?(mod_x, mod_y)
      end
    end
  end

  def valid_move?(row_num, col_num)
    return true if row_num >= 0 && row_num <= 7 && col_num >= 0 && col_num <= 7

    false
  end

end

class Node
  attr_accessor :x_cord, :y_cord, :dist, :parent

  def initialize(x_cord, y_cord, dist = 0, parent = nil)
    self.x_cord = x_cord
    self.y_cord = y_cord
    self.dist = dist
    self.parent = parent
  end
end

def start_game
  board = Game.new
  board.make_board
  board.show_board
  board.start_knight
  board.show_board
end

start_game
