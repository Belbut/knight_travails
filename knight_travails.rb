require './grid'

# Coordinate is a array with x and y information = [x,y]
#
class Node
  attr_reader :coordinate, :children, :parent

  def initialize(coordinate, children, parent = nil)
    @coordinate = coordinate
    @children = children
    @parent = parent
  end

  def to_s
    @coordinate.inspect
  end

  def inspect
    "N:#{coordinate.inspect}(#{children.size})"
  end
end

class Tree
  def initialize(coordinate)
    @grid = Grid.new(8, 8)
    @moving_pattern = ChessPiece::Knight::MOVING_PATTERN
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
    Node.new(coordinate, all_possible.map { |coord| build_tree(coord) })
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

module ChessPiece
  class Knight
    MOVING_PATTERN = [[+2, 1], [+2, -1], [+1, +2], [+1, -2], [-1, +2], [-1, -2], [-2, 1], [-2, -1]].freeze
  end
end
