extends BasePiece

class_name Pawn

func can_move_to():
    var tiles : Array = []

    var fwd = Vector2(current_tile.x - 1, current_tile.y)
    if boardScene.is_steppable(fwd):
        tiles.push_back(fwd)

    var fwd_left = Vector2(current_tile.x-1, current_tile.y-1)
    if boardScene.is_inbounds(fwd_left) and boardScene.get_tile(fwd_left).contains_enemy():
        tiles.append(fwd_left)
    
    var fwd_right = Vector2(current_tile.x-1, current_tile.y+1)
    if boardScene.is_inbounds(fwd_right) and boardScene.get_tile(fwd_right).contains_enemy():
        tiles.append(fwd_right)

    return tiles
