extends Popup

onready var Vol_Slider =$MarginContainer/Setting/VolumeSLider
onready var FullS_Btn = $MarginContainer/Setting/FSButton
onready var DisFPS_Btn = $MarginContainer/Setting/FPSButton
onready var SFX_Slider = $MarginContainer/Setting/SFXSlider



func _ready():
	Vol_Slider.value = Save.game_data.master_vol
	SFX_Slider.value = Save.game_data.Sfx_vol
	FullS_Btn.pressed = Save.game_data.fullscreen
	DisFPS_Btn.pressed = Save.game_data.display_fps



func _on_VolumeSLider_value_changed(value):
	GameSetting.Update_Volume(value)

func _on_FSButton_toggled(button_pressed):
	GameSetting.toogle_fullscreen(button_pressed)

func _on_FPSButton_toggled(button_pressed):
	GameSetting.toogle_fps_display(button_pressed)

func _on_SFXSlider_value_changed(value):
	GameSetting.Update_Sfx(value)

func _on_Button_test_pressed():
	print(Save.game_data)
