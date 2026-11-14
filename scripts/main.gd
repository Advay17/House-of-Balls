extends Node2D

enum Team {
	Red,
	Blue
}

@onready var red = $Red
@onready var blue = $Blue
@onready var ui = $UI
@onready var ball = $Ball

var red_lives = 3
var blue_lives = 3

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()
	get_tree().paused = true
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	red.position = Vector2(219.0, 450)
	blue.position = Vector2(931.0, 450)
	ball.needs_reset = true
	pass

func start_game():
	await ui.ready_process()
	get_tree().paused = false
	paused = false
	await ui.start_process()

func _on_hit(team: int) -> void:
	if paused:
		return
	paused = true
	get_tree().paused = true
	if team==Team.Red:
		red_lives-=1
		ui.set_health(team, red_lives)
	else:
		blue_lives-=1
		ui.set_health(team, blue_lives)
	if red_lives<=0 or blue_lives<=0:
		ui.set_health(team, blue_lives)
		ui.end_game(team)
		return
	reset()
	await start_game()
	
	pass # Replace with function body.
