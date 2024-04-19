extends Control

onready var EBar = $ELbar
onready var ETx = $PGbox/PGLeft
onready var main = $"/root/Main"

func _enemy_killed():
	
	EBar.value += 1
	if main.jumlah_musuh == 0:
		$PGbox.hide()
		EBar.hide()
		$Done.show()
	ETx.text = str(main.jumlah_musuh)
	
