extends Control

onready var EBar = $ELbar
onready var ETx = $ELlbl
onready var main = $"/root/Main"

func _enemy_killed():
	
	EBar.value += 1
	if main.jumlah_musuh == 0:
		ETx.hide()
		EBar.hide()
		$Done.show()
	ETx.text = "Sisa musuh: " + str(main.jumlah_musuh)

