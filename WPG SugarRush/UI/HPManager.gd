extends Control


var hp_size: int = 126

func _ready():
	$DiedM.hide()

func on_player_life_changed(player_hp: int)-> void:
	var texture_size = $HP.texture.get_size()
	var new_width = player_hp * hp_size
	var new_height = texture_size.y
	$HP.rect_size = Vector2(new_width, new_height)
	print("Received life_changed signal with HP: ", player_hp)
	print($HP.rect_size)

func _on_Player_Dead():
	$DiedM.show()

