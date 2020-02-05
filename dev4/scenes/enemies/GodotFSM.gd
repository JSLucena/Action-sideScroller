extends "res://scenes/FSM.gd"

onready var parent = get_parent()
var count = 0



func _ready():
	add_state("idle")
	add_state("attack")
	add_state("follow")
	pass 

func _state_logic(delta):
	
	
	#parent.apply_movement() #movement without gravity
	#parent.apply_gravity(count,delta) #gravity

	match state:
		states.run:
			pass


func _get_transition(delta):
	match state:
		states.idle:
			pass
			
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			pass


