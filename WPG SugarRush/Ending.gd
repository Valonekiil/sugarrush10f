extends Control

func _ready():
	BgmTes.play_bgm(3)

func _on_Button_pressed():
	get_tree().change_scene("res://MainM.tscn")
