extends CharacterBody2D

enum Team {
	Red,
	Blue
}

enum CharacterState {
	Normal,
	Parrying,
	Cooldown
}

@export var TEAM: Team
@export var RED_TEXTURE:Texture2D
@export var BLUE_TEXTURE:Texture2D

@onready var sprite:Sprite2D = $Sprite
@onready var parry_box:Area2D = $ParryBox
@onready var parry_flash:Timer = $ParryFlashTimer

var parry_on_cooldown = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const PARRY_SPEED = 1000

var inv = false

#signal update_velocity(velocity:Vector2, torque:float)

signal successful_parry
signal parry_ended
signal hit(team:Team)

func _ready() -> void:
	sprite.texture = RED_TEXTURE if TEAM==Team.Red else BLUE_TEXTURE

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("%s_up" % get_team_string()) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("%s_left" % get_team_string(), "%s_right" % get_team_string())
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
func _process(delta: float) -> void:
	pass
	#for i in get_slide_collision_count():
		#var collider = get_slide_collision(i).get_collider()
		#if collider.get_class() == "RigidBody2D":
			#hit.emit(TEAM)

func _input(event):
	if event.is_action_pressed("%s_parry" % get_team_string()):
		parry()

func get_team_string():
	return "red" if TEAM == Team.Red else "blue"

func parry():
	if parry_on_cooldown:
		return
	sprite.material.set_shader_parameter("state", CharacterState.Parrying)
	parry_flash.start()
	var overlapping_bodies = parry_box.get_overlapping_bodies()
	if not overlapping_bodies.is_empty():
		successful_parry.emit()
		for body:RigidBody2D in overlapping_bodies:
			var char2bod = get_angle_to(body.position)
			body.linear_velocity = Vector2(PARRY_SPEED * cos(char2bod), PARRY_SPEED * sin(char2bod))
			body.apply_torque_impulse(2000 * sign(cos(char2bod)))
			
			inv=true
			await get_tree().create_timer(0.2).timeout
			inv=false
		get_tree().paused=true
	else:
		parry_on_cooldown = true
		await get_tree().create_timer(1).timeout
		parry_on_cooldown = false
		sprite.material.set_shader_parameter("state",CharacterState.Normal)


func _on_parry_flash_timer_timeout() -> void:
	if get_parent().paused == false:
		get_tree().paused = false
	sprite.material.set_shader_parameter("state", CharacterState.Cooldown if parry_on_cooldown else CharacterState.Normal)
	parry_ended.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not inv:
		hit.emit(TEAM)
	pass # Replace with function body.
