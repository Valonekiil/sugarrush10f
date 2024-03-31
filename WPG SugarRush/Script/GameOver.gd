extends Control

func _ready():
	$Retry.grab_focus()

func _on_Retry_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Back_pressed():
	get_tree().quit()
