extends Control

var hp_size: int = 126

func on_player_life_changed(Player_HP: float)-> void:
	$Klitih.rect_size.x = Player_HP * hp_size
	print("Received life_changed signal with HP: ", Player_HP)
	print($Klitih.rect_size)
