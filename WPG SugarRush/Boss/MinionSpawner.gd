extends Node

export (PackedScene) var minion_scene  # Ganti dengan path ke scene minion Anda
export (int) var max_minions = 5  # Jumlah maksimum minion yang akan di-spawn
export (float) var spawn_delay = 0.5


var minions_spawned = 0
var spawn_timer = 0.0

func _process(delta):
	if minions_spawned < max_minions:
		spawn_timer += delta
		if spawn_timer >= spawn_delay:
			spawn_timer = 0.0
			spawn_minion()

func spawn_minions():
	for spawn_point in get_children():
		if spawn_point is Position2D:
			var minion_instance = minion_scene.instance()
			minion_instance.global_position = spawn_point.global_position
			get_parent().connect_minion_signal(minion_instance)  # Memanggil fungsi pada skrip boss
			get_parent().add_child(minion_instance)
			minions_spawned += 1
			break

func spawn_minion():
	minions_spawned = 0
