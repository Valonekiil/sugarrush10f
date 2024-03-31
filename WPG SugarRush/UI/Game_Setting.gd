extends Node

signal fps_displayed(value)

func toogle_fullscreen(value):
	OS.window_fullscreen = value
	#Save.game_data.fullscreen

func toogle_fps_display(value):
	emit_signal("fps_displayed", value)
	#Save.game_data.display_fps

func Update_Volume(vol):
	AudioServer.set_bus_volume_db(0, vol)
	#Save.game_data.master_vol = vol
	

