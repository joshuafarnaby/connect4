# frozen_string_literal: true

require_relative 'graph'
require_relative 'player'

puts 'Welcome to Connect4!'

puts 'Player 1 please enter your name'
name1 = gets.chomp

puts 'Player 2 please enter your name'
name2 = gets.chomp

graph = Graph.new
player1 = Player.new(name1, 'X')
player2 = Player.new(name2, 'O')

player1_turn = true
win = false

current_round = 1

loop do
  break if current_round > graph.rows * graph.columns

  current_player = player1_turn ? player1 : player2

  graph.display_graph

  while true
    puts "#{current_player.name} please select which column to place your token"

    column = current_player.gets_column_number(graph.columns)

    break unless graph.graph[0][column - 1] != ' '

    puts 'That column is full - try again'
  end

  position = graph.put_token_into_graph(column, current_player.token)

  if current_round > 6 && graph.check_win(position, current_player.token)
    win = true
    break
  end

  player1_turn = !player1_turn
  current_round += 1
end

graph.display_graph

if win
  puts "Congratulations #{player1_turn ? player1.name : player2.name} you win!"
else
  puts 'This one ended in a draw!'
end
