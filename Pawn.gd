extends BasePiece

class_name Pawn

func can_move_to():
    var fwd = Vector2(current_tile.x, current_tile.y-1)
    
    print(boardScene.is_steppable(fwd))
