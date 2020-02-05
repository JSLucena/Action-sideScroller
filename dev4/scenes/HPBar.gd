extends Control


onready var HP = $HP_Over
onready var tween_HP = $HP_Under
onready var curHP = $curHP
onready var update_tween = $updateTween

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0 , 1 , 0.05) var caution_zone = 0.5
export (float, 0 , 1 , 0.05) var danger_zone = 0.2

func _ready():
	pass


func update_health(value, old_health):
	
	tween_HP.value = old_health
	update_tween.interpolate_property(tween_HP, "value",tween_HP.value, tween_HP.value - value, 0.9,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	update_tween.start()
		
	HP.value = value
	curHP.text = str(value) + "/" + str(HP.max_value)
	assign_color(HP.value)
		
func update_max_health(value):
	HP.max_value = value 
	tween_HP.max_value = value
	curHP.text = str(value) + "/" + str(HP.max_value)

func assign_color(Health):

	if Health < HP.max_value * danger_zone:
			HP.tint_progress = danger_color
	else:
	
		if Health < HP.max_value * caution_zone:
			HP.tint_progress = caution_color
		else:
			HP.tint_progress = healthy_color
			
func set_min_health():
	HP.min_value = 0
	tween_HP.min_value = 0
