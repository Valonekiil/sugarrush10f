extends Control

onready var CB = $Bullet_box/Current_Ammo
onready var Max = $Bullet_box/Max_Ammo



func set_ammo(Cur_Bullet:int):
	if CB != null:
		CB.text = str(Cur_Bullet)
		print("Bullet now:"+ str(Cur_Bullet))
	else:
		print("CB is Nil")


#func set_max_ammo(Bullet:int):
#	Max.text = str(Bullet)

func is_reload(yoi:String):
	print(yoi)
	if yoi == "yes":
		$Bullet_box.hide()
		$Rilot.show()
	else:
		$Rilot.hide()
		$Bullet_box.show()
