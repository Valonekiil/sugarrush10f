extends Control

onready var CSSG = $Katsin_SG_Anim

func _ready():
	$Play_Button.hide()
	$Full.hide()
	hide_all()
	CSSG.play("Full_CC")
	#hide_all()

func _on_Play_Button_pressed():
	get_tree().change_scene("res://Tutorial.tscn")

func hide_all():
	$"1".hide()
	$"2".hide()
	$"3".hide()
	$"4".hide()

func show_all():
	$"1".show()
	$"2".show()
	$"3".show()
	$"4".show()


func _on_Katsin_SG_Anim_animation_finished(anim_name):
	get_tree().change_scene("res://Tutorial.tscn")



