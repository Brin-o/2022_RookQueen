extends BasePiece

class_name Pawn

func can_move_to():
    var tiles : Array = []

    var up = -1 if type == "Player" else 1

    var fwd = Vector2(current_tile.x+up, current_tile.y)
    if boardScene.is_steppable(fwd):
        tiles.push_back(fwd)

    var fwd_left = Vector2(current_tile.x+up, current_tile.y-1)
    if boardScene.is_inbounds(fwd_left) and boardScene.get_tile(fwd_left).contains_opponent(type):
        tiles.append(fwd_left)
    
    var fwd_right = Vector2(current_tile.x+up, current_tile.y+1)
    if boardScene.is_inbounds(fwd_right) and boardScene.get_tile(fwd_right).contains_opponent(type):
        tiles.append(fwd_right)

    return tiles

func move_to(var pos : Vector2):
    if boardScene.get_tile(pos).contains_opponent(type):
        position = boardScene.board_position(pos)
        var killed = boardScene.get_tile(pos).contains.take_damage(damage)
        if killed:
            .move_to(pos)
        else:
            #wait for a bi                                  t
            position = boardScene.board_position(current_tile)
    else:
        .move_to(pos)