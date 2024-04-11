extends Popup

onready var Vol_Slider =$MarginContainer/Setting/VolumeSLider
onready var FullS_Btn = $MarginContainer/Setting/FSButton
onready var DisFPS_Btn = $MarginContainer/Setting/FPSButton



func _ready():
	#Vol_Slider.value = Save.game_data.master_vol
	#FullS_Btn.pressed = Save.game_data.fullscreen
	#DisFPS_Btn.pressed = Save.game_data.display_fps
	pass


func _on_VolumeSLider_value_changed(value):
	GameSetting.Update_Volume(value)

func _on_FSButton_toggled(button_pressed):
	GameSetting.toogle_fullscreen(button_pressed)

func _on_FPSButton_toggled(button_pressed):
	GameSetting.toogle_fps_display(button_pressed)




