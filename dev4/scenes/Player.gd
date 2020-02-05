extends Node2D

var velocity = Vector2(0,0)
var movements = []
var sys = []
var combo = []

var side = "right"
var is_jumping = false
export var char_select = "Kirito"
var attack = false

signal damage(body, dmg)

###################COMBO SYSTEM##########################
var append = true

var atk1 = false
var atk2 = false
########################################################
func _ready():
	#print("res://scenes/characters/" + char_select +  ".tscn")
	var character_scene = load("res://scenes/characters/" + char_select +  ".tscn")
	var char_node = character_scene.instance()
	char_node.set_name("Character")
	add_child(char_node)
	#print(self.get_node("Character").name)
	
	$Character.connect("hit", self , "_on_hit")
	pass 

func get_mov_input():
	if(Input.is_action_pressed("ui_right")):
		movements.append("right")
	if(Input.is_action_pressed("ui_left")):
		movements.append("left")
	if(Input.is_key_pressed(KEY_SHIFT)):
		movements.append("shift")
	if(Input.is_key_pressed(KEY_SPACE)):
		movements.append("space")
			

func get_sys_input():
	if combo.size() > 5:
		_on_comboReset_timeout()
	
	if(Input.is_key_pressed(KEY_Z)):
		sys.append("Z")
		attack = true
		if(append == true):
			append = false
			combo.append("Z")
			$comboAppend.start()
	if(Input.is_key_pressed(KEY_SPACE)):
		sys.append("space")
	if(Input.is_key_pressed(KEY_X)):
		sys.append("X")
	if(Input.is_key_pressed(KEY_C)):
		sys.append("C")
	if(Input.is_key_pressed(KEY_CONTROL)):
		_on_comboReset_timeout()
		
func combo_sniffer():
	pass
	
			


func isOnFloor():
	return $Character.get_node("floorFinder1").is_colliding() or $Character.get_node("floorFinder2").is_colliding() or $Character.get_node("floorFinder3").is_colliding()
	
func apply_movement():
	velocity.x = 0
	if(movements.has("right")):
		side = "right"
		if(movements.has("shift")):
			velocity.x = $Character.speed + $Character.sprint_speed
		else:
			velocity.x = $Character.speed
	if(movements.has("left")):
		side = "left"
		if(movements.has("shift")):
			velocity.x = -($Character.speed + $Character.sprint_speed)
		else:
			velocity.x = -$Character.speed
	if(movements.has("space")):
		if is_jumping == false:
			velocity.y = $Character.jump


func apply_gravity(count, value):
	velocity.y = velocity.y + $Character.falling_speed * value * count
	if velocity.y > $Character.max_fall_speed:
		velocity.y = $Character.max_fall_speed

func clear_buffer():
	movements.clear()
	sys.clear()


func _on_comboReset_timeout():
	combo.clear()
	$PlayerFSM.cur_atk = 1
	


func _on_comboAppend_timeout():
	append = true
	
	
func _on_hit(body):
	var dmg = 0
	match $PlayerFSM.cur_atk:
		1: dmg = $Character.damage
		2: dmg = $Character.damage * 1.2
		3: dmg = $Character.damage * 1.5
		
	emit_signal("damage",body,dmg)


