require './knight_travails'

rook = ChessPiece.new(ChessPiece::Rook)
knight = ChessPiece.new(ChessPiece::Knight)
bishop = ChessPiece.new(ChessPiece::Bishop)
queen = ChessPiece.new(ChessPiece::Queen)
king = ChessPiece.new(ChessPiece::King)

p rook.path([0, 0], [7, 7])
p knight.path([0, 0], [7, 7])
p bishop.path([0, 0], [7, 7])
p queen.path([0, 0], [7, 7])
p king.path([0, 0], [7, 7])
