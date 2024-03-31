extends Control

func _ready():
	# Sembunyikan PauseMenu saat permainan dimulai
	visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		# Jika tombol pause ditekan, tampilkan/sembunyikan PauseMenu
		visible = !visible
		# Hentikan/jalankan game saat pause menu ditampilkan/disembunyikan
		get_tree().paused = visible

func _on_ResumeButton_pressed():
	visible = false
	get_tree().paused = false

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
