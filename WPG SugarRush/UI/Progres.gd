extends Control

onready var EBar = $ELbar
onready var ETx = $PGbox/PGLeft
onready var main = $"/root/Main"
onready var T = $"/root/Tutorial"

func _enemy_killed():
	print(str(main.jumlah_musuh))
	EBar.value += 1
	if main.jumlah_musuh == 0:
		$PGbox.hide()
		EBar.hide()
		$Done.show()
	ETx.text = str(main.jumlah_musuh)
	
func _enemy_killedT():
	
	EBar.value += 1
	if T.jumlah_musuh == 0:
		$PGbox.hide()
		EBar.hide()
		$Done.show()
	ETx.text = str(T.jumlah_musuh)
