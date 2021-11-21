extends "res://resource/source/FSM.gd"

const UP = Vector2(0, -1) # constant indicating where is the floor kek
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
	add_state("run")
	add_state("sprint")
	add_state("falling") 
	add_state("jump")
	add_state("dash")
	add_state("attack") #basic attack state
	call_deferred("set_state",states.idle)



func clear_attack_animations():
	for i in range(1,4):
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(i) + "_R").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(i) + "_L").hide()


func _state_logic(delta):
	
	parent.clear_buffer() #clear movement and system buffers
	parent.get_mov_input() # movement input polling
	parent.test_dash() # for dash double-tap
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
		
		
		
	#print(parent.sprinting)
	#print(parent.dash_sniffer)
	pass
	############################################

	match state:
		states.run:
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_R").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_L").hide()
				parent.get_node("Character").get_node("animations").play("walking_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_R").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_L").show()
				parent.get_node("Character").get_node("animations").play("walking_L")
		states.sprint:
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_R").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_L").hide()
				parent.get_node("Character").get_node("animations").play("sprint_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_L").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_R").hide()
				parent.get_node("Character").get_node("animations").play("sprint_L")
		states.jump:
			count += 1 # for applying gravity formula
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").hide()
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
				
		states.falling:
			count += 1 # for applying gravity formula
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").hide()
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
				
		states.attack:
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_R").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_L").hide()
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_R").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_L").show()
				
		states.dash: #reusing jump animations
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").hide()
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").hide()
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
	parent.get_node("Character").move_and_slide(parent.velocity, UP) #move character
	


func _get_transition(delta):
	match state:
		states.idle:
			if !parent.get_node("Character").is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.falling
			elif parent.velocity.x != 0:
				if parent.sprinting == true:
					return states.sprint
				else:
					return states.run
			if parent.attack == true:
				return states.attack

		states.run:
			if !parent.get_node("Character").is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.x > 0:
					return states.falling
			if parent.dash == true:
				return states.dash
			elif parent.sprinting == true:
				return states.sprint
			elif parent.velocity.x == 0:
				return states.idle

		states.sprint:
			if !parent.get_node("Character").is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.x > 0:
					return states.falling
			elif parent.sprinting == false:
				return states.run
			elif parent.velocity.x == 0:
				return states.idle

		states.jump:
			if parent.get_node("Character").is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.falling
			if parent.dash == true:
				return states.dash 

		states.falling:
			if parent.get_node("Character").is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			if parent.dash == true:
				return states.dash	
		states.attack:
			if parent.get_node("Character").get_node("animations").is_playing() == false: #when it finishes attacking
				parent.attack = false #stops attacking	
			if(parent.attack == false):
				return states.idle
			if parent.velocity.x != 0:
				return states.run

		states.dash:
			if parent.get_node("Character").get_node("animations").is_playing() == false: #when it finishes dashing
				parent.dash = false #stops attacking
				return states.idle
			
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			count = 0
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("idle_R").show()
				parent.get_node("Character").get_node("animations").play("idle_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("idle_L").show()
				parent.get_node("Character").get_node("animations").play("idle_L")
			parent.get_node("Character").get_node("currentState").text = "idle"
			
		states.run:
			count = 0
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_R").show()
				parent.get_node("Character").get_node("animations").play("walking_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("walking_L").show()
				parent.get_node("Character").get_node("animations").play("walking_L")
			parent.get_node("Character").get_node("currentState").text = "run"

		states.run:
			count = 0
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_R").show()
				parent.get_node("Character").get_node("animations").play("sprint_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("sprint_L").show()
				parent.get_node("Character").get_node("animations").play("sprint_L")
			parent.get_node("Character").get_node("currentState").text = "sprint"

		states.jump:
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
				parent.get_node("Character").get_node("animations").play("jump_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
				parent.get_node("Character").get_node("animations").play("jump_L")
			parent.get_node("Character").get_node("currentState").text = "jump"
			parent.is_jumping = true

		states.falling:
			if previous_state != states.jump:
				if parent.side == "right":
					parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
					parent.get_node("Character").get_node("animations").play("jump_R")
				else:
					parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
					parent.get_node("Character").get_node("animations").play("jump_L")
			parent.get_node("Character").get_node("currentState").text = "fall"

		states.attack:
			#parent.get_node("Character").get_node("hitbox").get_node("hit").set_disabled(false)
			parent.get_node("comboReset").start()
			#parent.get_node("Character").get_node("animations").set_speed_scale(1.0)
			clear_attack_animations()
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_R").show()
				
				parent.get_node("Character").get_node("animations").play("attack"+ str(cur_atk) + "_R")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("attack"+ str(cur_atk) + "_L").show()
				parent.get_node("Character").get_node("animations").play("attack"+ str(cur_atk) + "_L")
				
			parent.get_node("Character").get_node("currentState").text = "attack"

		states.dash:
			parent.get_node("Character").get_node("animations").set_speed_scale(1.5)
			if parent.side == "right":
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").show()
				parent.get_node("Character").get_node("animations").play("jump_L")
			else:
				parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").show()
				parent.get_node("Character").get_node("animations").play("jump_R")
				parent.get_node("Character").get_node("currentState").text = "dash"
				parent.is_jumping = false

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			parent.get_node("Character").get_node("sprite_collection").get_node("idle_L").hide()
			parent.get_node("Character").get_node("sprite_collection").get_node("idle_R").hide()
		states.run:
			parent.get_node("Character").get_node("sprite_collection").get_node("walking_R").hide()
			parent.get_node("Character").get_node("sprite_collection").get_node("walking_L").hide()
		states.sprint:
			parent.get_node("Character").get_node("sprite_collection").get_node("sprint_R").hide()
			parent.get_node("Character").get_node("sprite_collection").get_node("sprint_L").hide()
		states.jump:
			pass
		states.falling:
			parent.is_jumping = false
			parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").hide()
			parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").hide()
			
		states.attack:
			#parent.get_node("Character").get_node("hitBox").get_node("hit").set_disabled(true)
			added_to_combo = false
			parent.attack = false
			clear_attack_animations()
			#parent.get_node("Character").get_node("animations").set_speed_scale(1.0)
			cur_atk += 1
			if(cur_atk > 3):
				cur_atk = 1
			parent.get_node("comboReset").start()
			parent.get_node("atkReset").start()
			
		states.dash:
			parent.get_node("Character").get_node("animations").set_speed_scale(1.0)
			parent.get_node("Character").get_node("sprite_collection").get_node("jump_R").hide()
			parent.get_node("Character").get_node("sprite_collection").get_node("jump_L").hide()
			parent.dash_sniffer.clear()


func _on_atkReset_timeout():
	last_atk = 0
	pass # Replace with function body.
