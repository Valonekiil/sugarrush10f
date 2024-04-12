extends Node

const SAVEFILE = "user://SAFEFILE.save"

var game_data = {}

func _ready():
	load_data()
	print(game_data)

func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_data = {
			"master_vol": -5,
			"Sfx_vol": -5,
			"fullscreen":false,
			"display_fps":false
		}
		save_data()
		print("Data added")
	file.open(SAVEFILE,File.READ)
	game_data =file.get_var()
	file.close()
	print("Old data loaded")

func save_data():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()
	print("save")
