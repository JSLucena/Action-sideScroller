extends "res://resource/source/FSM.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var parent = get_parent()
var character 
var count = 0
var debug_combo = ""

var added_to_combo = false

var current_atk_anim
var cur_atk = 1
var last_atk = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	add_state("idle")
	add_state("run") #run and sprint state
	add_state("falling") 
	add_state("jump")
	add_state("attack") #basic attack state
	call_deferred("set_state",states.idle)


func _state_logic(delta):
	
	
	parent.get_mov_input() # movement input polling
	parent.get_sys_input() # system input and other commands(attack, block, etc) polling
	
	parent.combo_sniffer() # for special skills tracking
	parent.apply_movement() #movement without gravity
	parent.apply_gravity(count,delta) #gravity
	################debug#######################
	debug_combo = ""
	
	if parent.combo.size() > 0:
		for i in range(0,parent.combo.size()):
			debug_combo += parent.combo[i] + ","
		parent.get_node("Character").get_node("combo").text = debug_combo
	else:
		parent.get_node("Character").get_node("combo").text = "empty"	
	############################################

	match state:
		states.run:
			if parent.side == "right":
				parent.get_node("Character").get_node("walk").show()
				parent.get_node("Character").get_node("walk_rev").hide()
				parent.get_node("Character").get_node("animations").play("Walk_R")
			else:
				parent.get_node("Character").get_node("walk").hide()
				parent.get_node("Character").get_node("walk_rev").show()
				parent.get_node("Character").get_node("animations").play("Walk_L")
				
		states.jump:
			count += 1 # for applying gravity formula
			if parent.side == "right":
				parent.get_node("Character").get_node("jump").show()
				parent.get_node("Character").get_node("jump_rev").hide()
			else:
				parent.get_node("Character").get_node("jump").hide()
				parent.get_node("Character").get_node("jump_rev").show()
				
		states.falling:
			count += 1 # for applying gravity formula
			if parent.side == "right":
				parent.get_node("Character").get_node("jump").show()
				parent.get_node("Character").get_node("jump_rev").hide()
			else:
				parent.get_node("Character").get_node("jump").hide()
				parent.get_node("Character").get_node("jump_rev").show()
				
		states.attack:
			if parent.side == "right":
				parent.get_node("Character").get_node("attack_"+ str(cur_atk)).show()
				parent.get_node("Character").get_node("attack_"+ str(cur_atk) + "_rev").hide()
			else:
				parent.get_node("Character").get_node("attack_"+ str(cur_atk)).hide()
				parent.get_node("Character").get_node("attack_"+ str(cur_atk) + "_rev").show()
				
			
	parent.get_node("Character").move_and_collide(parent.velocity * delta) #move character
	parent.clear_buffer() #clear movement and system buffers


func _get_transition(delta):
	match state:
		states.idle:
			if !parent.isOnFloor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.falling
			elif parent.velocity.x != 0:
				return states.run
			if parent.attack == true:
				return states.attack

		states.run:
			if !parent.isOnFloor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.x > 0:
					return states.falling
			elif parent.velocity.x == 0:
				return states.idle

		states.jump:
			if parent.isOnFloor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.falling

		states.falling:
			if parent.isOnFloor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
				
		states.attack:
			if parent.get_node("Character").get_node("animations").is_playing() == false: #when it finishes attacking
				parent.attack = false #stops attacking
				
			
			if(parent.attack == false):
				return states.idle
				
			elif parent.velocity.x != 0:
				return states.run
			
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			count = 0
			if parent.side == "right":
				parent.get_node("Character").get_node("idle_R").show()
				parent.get_node("Character").get_node("animations").play("idle_R")
			else:
				parent.get_node("Character").get_node("idle_L").show()
				parent.get_node("Character").get_node("animations").play("idle_L")
			parent.get_node("Character").get_node("currentState").text = "idle"
			
		states.run:
			count = 0
			if parent.side == "right":
				parent.get_node("Character").get_node("walking_R").show()
				parent.get_node("Character").get_node("animations").play("walking_R")
			else:
				parent.get_node("Character").get_node("walking_L").show()
				parent.get_node("Character").get_node("animations").play("walking_L")
			parent.get_node("Character").get_node("currentState").text = "run"

		states.jump:
			if parent.side == "right":
				parent.get_node("Character").get_node("jump_R").show()
				parent.get_node("Character").get_node("animations").play("jump_R")
			else:
				parent.get_node("Character").get_node("jump_L").show()
				parent.get_node("Character").get_node("animations").play("jump_L")
			parent.get_node("Character").get_node("currentState").text = "jump"
			parent.is_jumping = true

		states.falling:
			if previous_state != states.jump:
				if parent.side == "right":
					parent.get_node("Character").get_node("jump_R").show()
					parent.get_node("Character").get_node("animations").play("jump_R")
				else:
					parent.get_node("Character").get_node("jump_L").show()
					parent.get_node("Character").get_node("animations").play("jump_L")
			parent.get_node("Character").get_node("currentState").text = "fall"

		states.attack:
			parent.get_node("Character").get_node("hitBox").get_node("hit").set_disabled(false)
			parent.get_node("comboReset").start()
			parent.get_node("Character").get_node("animations").set_speed_scale(1.35)
			if parent.side == "right":
				parent.get_node("Character").get_node("attack_"+ str(cur_atk) + "_R").show()
				
				parent.get_node("Character").get_node("animations").play("attack_"+ str(cur_atk) + "_R")
			else:
				parent.get_node("Character").get_node("Attack_"+ str(cur_atk) + "_L").show()
				parent.get_node("Character").get_node("animations").play("attack_"+ str(cur_atk) + "_L")
				
			parent.get_node("Character").get_node("currentState").text = "attack"

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			parent.get_node("Character").get_node("idle_L").hide()
			parent.get_node("Character").get_node("idle_R").hide()
		states.run:
			parent.get_node("Character").get_node("walk_R").hide()
			parent.get_node("Character").get_node("walk_L").hide()
		states.jump:
			pass
		states.falling:
			parent.is_jumping = false
			parent.get_node("Character").get_node("jump_R").hide()
			parent.get_node("Character").get_node("jump_L").hide()
			
		states.attack:
			parent.get_node("Character").get_node("hitBox").get_node("hit").set_disabled(true)
			added_to_combo = false
			parent.attack = false
			parent.get_node("Character").get_node("attack_"+ str(cur_atk) + "_R").hide()
			parent.get_node("Character").get_node("attack_"+ str(cur_atk) + "_L").hide()
			parent.get_node("Character").get_node("animations").set_speed_scale(1.0)
			cur_atk += 1
			if(cur_atk > 3):
				cur_atk = 1
			parent.get_node("comboReset").start()
			parent.get_node("atkReset").start()


func _on_atkReset_timeout():
	last_atk = 0
	pass # Replace with function body.
