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
		yield(get_tree().create_timer(5.0), "timeout")
		$Done.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Done2.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$Done2.hide()
	ETx.text = str(main.jumlah_musuh)
	print(main.jumlah_musuh)

func _enemy_killed_M_J():
	main.jumlah_musuh -= 1
	EBar.value += 1
	if main.jumlah_musuh == 0:
		$PGbox.hide()
		EBar.hide()
		$Done.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$Done.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Done2.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$Done2.hide()
	ETx.text = str(main.jumlah_musuh)
	print(main.jumlah_musuh)


func _enemy_killedT():
	
	EBar.value += 1
	if T.jumlah_musuh == 0:
		$PGbox.hide()
		EBar.hide()
		$Done.show()
		yield(get_tree().create_timer(2.0), "timeout")
		$Done.hide()
		yield(get_tree().create_timer(1.0), "timeout")
		$Done2.show()
		yield(get_tree().create_timer(2.0), "timeout")
		$Done2.hide()
	ETx.text = str(T.jumlah_musuh)
