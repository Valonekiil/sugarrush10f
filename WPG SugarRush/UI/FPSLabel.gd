extends Label

func _ready():
	GameSetting.connect("fps_displayed",self,"on_fps_displayed")

func _process(delta):
	text = "FPS:" + str([Engine.get_frames_per_second()]) 

func on_fps_displayed(value):
	visible = value
