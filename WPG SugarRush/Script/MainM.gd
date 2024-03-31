extends Control

onready var Option_Menu = $OptionM
onready var CreditM = $CreditM

func _on_PlayB_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_ExitB_pressed():
	get_tree().quit()


func _on_OptionB_pressed():
	Option_Menu.popup()


func _on_CreditB_pressed():
	CreditM.popup()
