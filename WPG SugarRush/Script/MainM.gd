extends Control

onready var Option_Menu = $OptionM
onready var CreditM = $CreditM



func _ready():
	BgmTes.play_bgm(3)

func _on_PlayB_pressed():
	if GameSetting.tutor == false:
		get_tree().change_scene("res://New_Katsin.tscn")
		
	else :
		$Tutor_conf.show()
		

func _on_ExitB_pressed():
	get_tree().quit()


func _on_OptionB_pressed():
	Option_Menu.popup()


func _on_CreditB_pressed():
	CreditM.popup()


func _on_TextureButton_pressed():
	Option_Menu.popup()

func _on_Button_pressed():
	get_tree().change_scene("res://New_Katsin.tscn")
	GameSetting.tutor = false


func _on_Button2_pressed():
	get_tree().change_scene("res://New_Katsin.tscn")
	
