extends Control

onready var CB = $Bullet_box/Current_Ammo
onready var Max = $Bullet_box/Max_Ammo
onready var Icon = $kon
onready var Pshot = $Pshot_box/Pshots

func CD(time:float)-> void:
	set_process(true)
	Icon.max_value = time
	$Timer.start(time)

func _ready():
	set_process(false)

func _process(delta):
	Icon.value = $Timer.time_left
	


func set_ammo(Cur_Bullet:int):
	if CB != null:
		CB.text = str(Cur_Bullet)
		print("Bullet now:"+ str(Cur_Bullet))
	else:
		print("CB is Nil")

func set_pshot( Pshots:int):
	if Pshot != null:
		Pshot.text = str(Pshots)
		print("SKill now:" + str(Pshots))
	else:
		print("Kontol nulll")



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
