extends KinematicBody2D

export var player_stats: Resource = null

onready var max_speed = player_stats.normal_speed
onready var timer_speed_pickup := $TimerSpeedPickUp
onready var timer_attack_pickup := $TimerAttackPickUp
onready var timer_gold_pickup := $TimerGoldPickUp

var direction := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready() -> void:
	timer_speed_pickup.connect("timeout", self, "toggle_speed_pickup_effect", [false])

### Movement

func _physics_process(delta: float) -> void:
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
	
### PICKUPS ###

func add_gold(is_on:bool) -> void:
	if is_on:
		timer_gold_pickup.start()
		player_stats.gold += 10
		
func add_gold_stack(is_on: bool) -> void:
	if is_on:
		timer_gold_pickup.start()
		player_stats.gold += 30

func toggle_attack_boost_effect(is_on: bool) -> void:
	if is_on:
		timer_attack_pickup.start()
		player_stats.turret_cannon_attack = player_stats.turret_cannon_attack * 2
		
func toogle_cooldown_pickup(is_on:bool) -> void:
	if is_on:
		timer_attack_pickup.start()
		player_stats.turret_cooldown = player_stats.turret_cooldown * 0.5
		
func toggle_heal_effect(is_on: bool) -> void:
	if is_on:
		player_stats.health += 25

func toggle_speed_pickup_effect(is_on: bool) -> void:
	if is_on:
		timer_speed_pickup.start()
		max_speed = player_stats.boost_speed
	else:
		max_speed = player_stats.normal_speed
		
		
