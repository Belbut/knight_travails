class Grid
  attr_accessor :total_cells, :state_of_cells
  attr_reader :height, :width
  
  def initialize(height, width)
    @height = height
    @width = width
    @total_cells = height * width
    @state_of_cells = Array.new(height) { Array.new(width, 1) }
  end

  def to_s
    result = '    '
    state_of_cells[0].each_with_index { |_, index| result << "#{index}  " }
    result << "\n"
    state_of_cells.each_with_index { |row, index| result << "#{index.to_s.ljust(2)} #{row.inspect}\n" }
    result
  end

  def possible_cell?(coordinate)
    return false if (coordinate[0]).negative? || (coordinate[1]).negative?

    @state_of_cells.dig(coordinate[0], coordinate[1]) == 1
  end
end
