extends "res://scenes/FSM.gd"

onready var parent = get_parent()
onready var detection = get_parent().get_node("Detection")
var count = 10

var chase_direction = "right"

func _ready():
	add_state("idle")
	add_state("attack")
	add_state("follow")
	call_deferred("set_state",states.idle)
	pass 

func _state_logic(delta):
	
	
	
	parent.apply_gravity(count,delta) #gravity
	
	
	match state:
		states.idle:
			pass
		states.follow:
			if(parent.player_is_in_range == true):
				parent.find_player_pos(parent.player_body)
				if (parent.player_in_range - parent.position).x > 0:
					chase_direction = "right"
				else:
					chase_direction = "left"
			if(parent.get_node("MovementTimer").is_stopped()):
				parent.apply_movement(chase_direction) #movement without gravity
				
				parent.get_node("MovementTimer").start()
			parent.move_and_collide(parent.velocity * delta)
			#chase


func _get_transition(delta):
	match state:
		states.idle:
			if(parent.player_is_in_range == true):
				return states.follow
		states.follow:
			if(parent.player_is_in_range == false):
				return states.idle
			pass
			
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.follow:
			parent.get_node("MovementTimer").start()

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			pass


