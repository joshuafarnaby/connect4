# frozen_string_literal: true

class Graph
  attr_accessor :graph, :rows, :columns

  def initialize(n_rows = 6, n_cols = 7)
    @rows = n_rows > 9 ? 9 : n_rows.abs
    @columns = n_cols > 9 ? 9 : n_cols.abs

    @graph = build_graph(@rows, @columns)
  end

  def build_graph(n_rows, n_cols)
    graph = []

    n_rows.times do
      row = []
      n_cols.times { row.push(' ') }
      graph.push(row)
    end

    graph
  end

  def put_token_into_graph(column, token, row = 0)
    col_index = column - 1
    row_index = row

    current_row = @graph[row_index]
    next_row = @graph[row_index + 1]

    if next_row.nil?
      current_row[col_index] = token
      [row_index, col_index]
    elsif next_row[col_index] == ' '
      put_token_into_graph(column, token, row_index + 1)
    else
      current_row[col_index] = token
      [row_index, col_index]
    end
  end

  def check_win(position, token)
    row_index = position[0]
    col_index = position[1]

    return true if check_vertical(col_index, token)
    return true if check_horizontal(row_index, token)
    return true if check_diagonal(row_index, col_index, token)

    false
  end

  def check_vertical(col_index, token)
    tokens_in_column = []
    @graph.each { |row| tokens_in_column.push(row[col_index]) }

    tokens_in_column.join.strip.match(/#{token}{4}/).nil? ? false : true
  end

  def check_horizontal(row_index, token)
    tokens_in_row = []
    @graph[row_index].each { |element| tokens_in_row.push(element) }

    tokens_in_row.join.strip.match(/#{token}{4}/).nil? ? false : true
  end

  def check_diagonal(row_index, col_index, token)
    last_token_placed = @graph[row_index][col_index]

    above_left = above_left(row_index - 1, col_index - 1, 1, 1, [])
    below_right = below_right(row_index + 1, col_index + 1, rows, columns, [])

    below_left = below_left(row_index + 1, col_index - 1, rows, 1, [])
    above_right = above_right(row_index - 1, col_index + 1, 1, columns, [])

    diagonal1 = (above_left + last_token_placed + below_right).to_s
    diagonal2 = (below_left + last_token_placed + above_right).to_s

    return true unless diagonal1.match(/#{token}{4}/).nil?
    return true unless diagonal2.match(/#{token}{4}/).nil?
  end

  def below_left(row_index, col_index, max_row, min_col, arr)
    return arr.join if row_index > max_row - 1 || col_index < min_col - 1

    if @graph[row_index][col_index] == ' '
      arr.join
    else
      arr.unshift(@graph[row_index][col_index])
      below_left(row_index + 1, col_index - 1, max_row, min_col, arr)
    end
  end

  def above_right(row_index, col_index, min_row, max_col, arr)
    return arr.join if row_index < min_row - 1 || col_index > max_col - 1

    if @graph[row_index][col_index] == ' '
      arr.join
    else
      arr.push(@graph[row_index][col_index])
      above_right(row_index - 1, col_index + 1, min_row, max_col, arr)
    end
  end

  def above_left(row_index, col_index, min_row, min_col, arr)
    return arr.join if row_index < min_row - 1 || col_index < min_col - 1

    if @graph[row_index][col_index] == ' '
      arr.join
    else
      arr.unshift(@graph[row_index][col_index])
      above_left(row_index - 1, col_index - 1, min_row, min_col, arr)
    end
  end

  def below_right(row_index, col_index, max_row, max_col, arr)
    return arr.join if row_index > max_row - 1 || col_index > max_col - 1

    if @graph[row_index][col_index] == ' '
      arr.join
    else
      arr.push(@graph[row_index][col_index])
      below_right(row_index + 1, col_index + 1, max_row, max_col, arr)
    end
  end

  def display_graph
    current_row = 0

    until current_row == @graph.length
      output = ''
      current_column = 0
      @graph[current_row].length.times do
        output += current_column == @graph[current_row].length - 1 ? (@graph[current_row][current_column]).to_s : "#{@graph[current_row][current_column]} "
        current_column += 1
      end

      puts "|#{output}|"
      current_row += 1
    end

    puts display_column_numbers
  end

  def display_column_numbers
    n_cols = @graph[0].length

    current_column = 1
    output = ''

    n_cols.times do
      output += "#{current_column} "
      current_column += 1
    end

    " #{output}"
  end
end
