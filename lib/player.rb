# frozen_string_literal: true

class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end

  def gets_column_number(max)
    loop do
      input = gets.chomp

      if input.to_i > max || !input.match(/[1-9]{1}/)
        puts 'That input was invalid - try again'
        next
      end

      return input.to_i.abs
    end
  end
end
