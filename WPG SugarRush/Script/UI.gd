extends CanvasLayer

onready var PauseB = $PauseB
onready var Paused = $PausedM
onready var Option = $OptionM


func _ready():
	Paused.hide()
	$Progres/Done.hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		PauseB.visible = !get_tree().paused
		Paused.visible = !PauseB.visible


func _on_PauseB_pressed():
	get_tree().paused = !get_tree().paused
	PauseB.visible = !get_tree().paused
	Paused.visible = !PauseB.visible

func _on_ResumeB_pressed():
	get_tree().paused = !get_tree().paused
	PauseB.visible = !get_tree().paused
	Paused.visible = !PauseB.visible

func _on_POptionB_pressed():
	Option.popup()

func _on_MainMB_pressed():
	get_tree().change_scene("res://MainM.tscn")
	get_tree().paused = false

func _on_ContinueB_pressed():
	get_tree().change_scene("res://Main.tscn")




