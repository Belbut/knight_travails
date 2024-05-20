require './grid'

# Coordinate is a array with x and y information = [x,y]
#
class Node
  attr_reader :coordinate, :children
  attr_accessor :parent

  def initialize(coordinate, children, parent = nil)
    @coordinate = coordinate
    @children = children
    @parent = parent
  end

  def to_s
    @coordinate.inspect
  end

  def inspect
    "N:#{coordinate.inspect}(#{children.size}) @ #{parent}"
  end
end

class Tree
  def initialize(coordinate, moving_pattern = ChessPiece::Knight::MOVING_PATTERN)
    @grid = Grid.new(8, 8)
    @moving_pattern = moving_pattern
    @root = build_tree(coordinate)
  end

  def build_tree(coordinate)
    return unless @grid.total_cells.positive?

    @grid.total_cells -= 1
    @grid.state_of_cells[coordinate[0]][coordinate[1]] = 0

    all_possible = @moving_pattern.reduce([]) do |accumulator, piece_move|
      possible_coordinate = [piece_move[0] + coordinate[0], piece_move[1] + coordinate[1]]
      if @grid.possible_cell?(possible_coordinate)
        @grid.state_of_cells[possible_coordinate[0]][possible_coordinate[1]] = 0
        accumulator << (possible_coordinate)
      else
        accumulator
      end
    end
    all_children_nodes = []
    node = Node.new(coordinate, all_possible.map do |coord|
      temp = build_tree(coord)
      all_children_nodes.append(temp) unless temp.nil?
      temp
    end)
    all_children_nodes.each { |child_node| child_node.parent = node }

    node
  end

  # The find uses a lever order traversal to find the first match
  def find(coordinate, queue = [@root])
    return if queue.empty?

    current_node = queue.shift
    return current_node if current_node.coordinate == coordinate

    queue.append(*current_node.children)
    find(coordinate, queue)
  end

  def print_simple(queue = [@root])
    return if queue.compact.empty?

    new_queue = []
    p queue
    until queue.empty?
      current_node = queue.shift
      current_node.children.compact.each do |node|
        new_queue.append(node)
      end
    end
    print_simple(new_queue)
  end
end

class ChessPiece
  def initialize(piece = Knight)
    @piece = piece
  end

  def path(start_position, end_position)
    movement_tree = Tree.new(start_position, @piece::MOVING_PATTERN)
    check_node = movement_tree.find(end_position)
    path = []

    until check_node.nil?
      path.prepend(check_node.coordinate)
      check_node = check_node.parent
    end
    path
  end

  class Rook
    def self.pattern
      result = []
      (-7..+7).each do |i|
        next if i.zero?

        result << [i, 0]
        result << [0, i]
      end
      result.sort
    end

    MOVING_PATTERN = pattern.freeze
  end

  class Knight
    MOVING_PATTERN = [[+2, 1], [+2, -1], [+1, +2], [+1, -2], [-1, +2], [-1, -2], [-2, 1], [-2, -1]].sort.freeze
  end

  class Bishop
    def self.pattern
      result = []
      (-7..+7).each do |i|
        next if i.zero?

        result << [i, i]
        result << [-i, i]
      end
      result.sort
    end

    MOVING_PATTERN = pattern.freeze
  end

  class Queen
    def self.pattern
      result = []
      (-7..+7).each do |i|
        next if i.zero?

        result << [i, i]
        result << [-i, i]
        result << [0, i]
        result << [i, 0]
      end
      result.sort
    end

    MOVING_PATTERN = pattern.freeze
  end

  class King
    def self.pattern
      result = []
      (-1..+1).each do |i|
        next if i.zero?

        result << [i, i]
        result << [-i, i]
        result << [0, i]
        result << [i, 0]
      end
      result.sort
    end

    MOVING_PATTERN = pattern.freeze
  end

  class Pawn
    MOVING_PATTERN = [[0, 1]].freeze
    KILLING_PATTERN = [[-1, 1], [1, 1]].freeze
  end
end
