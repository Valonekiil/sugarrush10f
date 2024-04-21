extends StaticBody2D

func _on_Barrel_area_entered(area):
	if area.is_in_group("bullet"):
		var kobis = load("res://Asset/Item/Kobis.tscn").instance()
		kobis.global_position = area.global_position
		var player = get_node("/root/Main/Player") # Ganti dengan path yang sesuai
		kobis.connect("Healed", player, "on_Player_Heal")
		get_parent().add_child(kobis)
		queue_free()
