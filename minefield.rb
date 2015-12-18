require 'pry'

class Minefield
  attr_reader :row_count, :column_count, :board_grid, :value_grid, :mine_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @board_grid = []
    @value_grid = {}
    make_value_grid
  end

  def make_mines
    mine_locations = []
    mine_locations = board_grid.sample(mine_count)

    mine_locations.each do |location|
      value_grid[location][1] = true
    end
  end


  def make_board_grid
    (0...row_count).each do |grid_row|
      (0...column_count).each do |grid_col|
        @board_grid << [grid_row, grid_col]
      end
    end
  end

  def make_value_grid
    make_board_grid
    @board_grid.each do |space|
      @value_grid[space] = [false, false]
    end
    make_mines
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @value_grid[[row, col]][0]
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    @value_grid[[row, col]][0] = true
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    @value_grid.any?{ |space, properties| properties == [true, true] }
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    !@value_grid.any?{ |space, properties| properties == [false, false] }
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    number_of_mines = 0
    spaces_to_scan = find_spaces_to_scan(row, col)
    spaces_to_scan.each do |space|
      number_of_mines += 1 if contains_mine?(space[0], space[1])
    end
    auto_clear
    number_of_mines
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @value_grid[[row, col]][1]
  end

  def find_spaces_to_scan(row, col)
    spaces_to_scan = []
    directions_to_search = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    directions_to_search.each do |direction|
      nearby_space = [row + direction[0], col + direction[1]]
      if !@value_grid[nearby_space].nil?
        spaces_to_scan << nearby_space
      end
    end
    spaces_to_scan
  end


  #def auto_clear_spaces

  #def spawn bombs after first click

end


# binding.pry
