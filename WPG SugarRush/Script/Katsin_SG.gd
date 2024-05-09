extends Control

onready var CSSG = $Katsin_SG_Anim

func _ready():
	$Play_Button.hide()
	$Full.hide()
	hide_all()
	CSSG.play("L_Anim")
	show_all()
	yield(get_tree().create_timer(12.5), "timeout")
	#hide_all()
	
	$Play_Button.show()

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
