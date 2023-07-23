extends KinematicBody2D

export var player_stats: Resource = null

onready var max_speed = player_stats.normal_speed

onready var timer_speed_pickup := $TimerSpeedPickUp
onready var timer_attack_pickup := $TimerAttackPickUp
onready var timer_gold_pickup := $TimerGoldPickUp
onready var timer_healing_pickup := $TimerHealingPickUp

onready var splash_particles := $SplashParticle
onready var splash_trail_particles := $SplashTrailParticle
onready var trail_particles := $TrailParticle
onready var speed_boost_particles := $SpeedBoostParticle
onready var healing_particles := $HealingParticle

signal update_health

var direction := Vector2.ZERO
var desired_velocity := Vector2.ZERO
var steering_vector := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready() -> void:
	timer_speed_pickup.connect("timeout", self, "toggle_heal_pickup_effect", [false])
	timer_healing_pickup.connect("timeout", self, "toggle_speed_pickup_effect", [false])
	timer_attack_pickup.connect("timeout", self, "toggle_attack_pickup_effect", [false])

### Movement

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("boost") and not get_node("Boost").time_left > 0:
		get_node("Boost").start()
		max_speed = player_stats.boost_speed
		speed_boost_particles.one_shot = true
		speed_boost_particles.emitting = true

	desired_velocity = max_speed * direction
	steering_vector = desired_velocity - velocity
	velocity += steering_vector * player_stats.drag_factor

	position += move_and_slide(velocity * delta)
	if direction:
		rotation = velocity.angle()

	splash_particles.emitting = velocity.length() > max_speed / 15.0
	splash_trail_particles.emitting = velocity.length() > max_speed / 15.0
	trail_particles.emitting = velocity.length() > max_speed / 15.0

func _on_Boost_timeout() -> void:
	max_speed = player_stats.normal_speed
	speed_boost_particles.one_shot = false
	speed_boost_particles.emitting = false

func take_damage(damage) -> void:
	player_stats.health -= damage
	emit_signal("update_health")
	print("player health: ", player_stats.health)

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
		
### Healing and speed particles are looping playback and else statement is not working
func toggle_heal_pickup_effect(is_on: bool) -> void:
	if is_on:
		timer_healing_pickup.start()
		player_stats.health += 25
		healing_particles.one_shot = true
		healing_particles.emitting = true
	else:
		player_stats.health = player_stats.health
		healing_particles.one_shot = false
		healing_particles.emitting = false

func toggle_speed_pickup_effect(is_on: bool) -> void:
	if is_on:
		timer_speed_pickup.start()
		max_speed = player_stats.boost_speed
		speed_boost_particles.one_shot = true
		speed_boost_particles.emitting = true
	else:
		max_speed = player_stats.normal_speed
		speed_boost_particles.one_shot = false
		speed_boost_particles.emitting = false
		
