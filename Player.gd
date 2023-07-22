extends KinematicBody2D

export var player_stats: Resource = null

onready var max_speed = player_stats.normal_speed
onready var timer_speed_pickup := $TimerSpeedPickUp

var direction := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready() -> void:
	timer_speed_pickup.connect("timeout", self, "toggle_speed_pickup_effect", [false])


func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("boost"):
		get_node("Boost").start()
		max_speed = player_stats.boost_speed

	desired_velocity = max_speed * direction
	steering_vector = desired_velocity - velocity
	velocity += steering_vector * player_stats.drag_factor

	position += move_and_slide(velocity * delta)
	if direction:
		rotation = velocity.angle()


func _on_Boost_timeout() -> void:
	max_speed = player_stats.normal_speed
	
func toggle_speed_pickup_effect(is_on: bool) -> void:
	if is_on:
		timer_speed_pickup.start()
		max_speed = player_stats.boost_speed
	else:
		max_speed = player_stats.normal_speed
		
