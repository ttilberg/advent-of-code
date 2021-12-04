input = File.read('data/4.txt')

class Bingo
  attr_reader :dobbs, :boards

  def initialize(input)
    dobbs, *boards = input.split("\n" * 2)
    @dobbs = dobbs.split(',').map(&:to_i)
    @boards = boards.map{|_board| Board.new(_board)}
  end

  def first_winner_score
    dobbs.each do |dobb|
      boards.each do |board|
        board.dobb(dobb)
        return board.score if board.winner?
      end
    end
  end

  def last_winner_score
    dobbs.each do |dobb|
      boards.each do |board|
        board.dobb(dobb)
      end
      if boards.one? && boards.last.winner?
        return boards.last.score
      end
      boards.delete_if(&:winner?)
    end
  end

  class Board
    attr_reader :rows, :last_dobb
    def initialize(board)
      @rows = board.split("\n")
                   .map {|row| row.scan(/\d+/)
                                  .map(&:to_i)}
      @last_dobb
    end

    def dobb(*called_numbers)
      called_numbers.each do |called_number|
        rows.map! do |row|
          row.map! do |val|
            called_number == val ? nil : val
          end
        end
        @last_dobb = called_number
      end
    end

    def columns
      rows.transpose
    end

    def winner?
      rows.any? {|row| row.all?(&:nil?)} ||
        columns.any? {|column| column.all?(&:nil?)}
    end

    def score
      rows.flatten.compact.sum * last_dobb
    end
  end
end

puts Bingo.new(input).last_winner_score

require 'minitest/autorun'

class BoardTest < Minitest::Test
  def setup
    @board = Bingo::Board.new(<<~BOARD)
      97 62 17  5 79
       1 99 98 80 84
      44 16  2 40 94
      68 95 49 32  8
      38 35 23 89  3
    BOARD
  end
  def test_win_by_rows
    @board.dobb(97, 62, 17, 5)
    refute @board.winner?, "The board should not be a winner yet."
    @board.dobb(79)
    assert @board.winner?, "The board should be a winner."
  end

  def test_win_by_columns
    @board.dobb(97, 1, 44, 68)
    refute @board.winner?, "The board should not be a winner yet."
    @board.dobb(38)
    assert @board.winner?, "The board should be a winner."
  end

  def test_score
    @board.dobb(97, 62, 17, 5, 79)
    assert_equal 78842, @board.score
  end
end

class BingoTest < Minitest::Test
  def test_score
    assert_equal 4512, Bingo.new(GAME).first_winner_score
  end

  def test_last_winner_score
    assert_equal 1924, Bingo.new(GAME).last_winner_score
  end

  GAME = <<~TXT
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
  TXT

end
