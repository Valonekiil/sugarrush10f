extends Node2D

func handle_bullet_spawned(bullet, position, direction):
	bullet.global_position = position
	bullet.set_direction(direction)
	add_child(bullet)
