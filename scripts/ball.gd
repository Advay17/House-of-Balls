extends RigidBody2D

@onready var sprite = $Sprite2D
var needs_reset = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if needs_reset:
		position = Vector2(1150./2., 214)
		linear_velocity = Vector2(1000, 0)
		angular_velocity = 1000
		needs_reset=false
func _on_successful_parry() -> void:
	sprite.material.set_shader_parameter("state",1)

func _on_parry_ended() -> void:
	sprite.material.set_shader_parameter("state",0)
