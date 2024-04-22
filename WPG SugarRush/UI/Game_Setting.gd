extends Node

signal fps_displayed(value)
onready var tutor:bool = false

func toogle_fullscreen(value):
	OS.window_fullscreen = value
	Save.game_data.fullscreen = value
	Save.save_data()

func toogle_fps_display(value):
	emit_signal("fps_displayed", value)
	Save.game_data.display_fps

func Update_Volume(vol):
	AudioServer.set_bus_volume_db(1, vol)
	Save.game_data.master_vol = vol
	Save.save_data()

func Update_Sfx(vol):
	AudioServer.set_bus_volume_db(2,vol)
	Save.game_data.Sfx_vol = vol
	Save.save_data()
