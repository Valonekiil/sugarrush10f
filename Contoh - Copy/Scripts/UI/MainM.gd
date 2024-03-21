extends Control



func _on_PlayB_pressed():
	get_tree().change_scene("res://Gameplay/Playfield.tscn")


func _on_ExitB_pressed():
	get_tree().quit()


