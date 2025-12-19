extends AnimatableBody3D

@export var pop_height := 0.16
@export var speed := 8.0

var start_y: float
var target_y: float
var is_up := false
var pop_time := 0.0

signal mole_down(mole, duration)
signal update_score

# Instantiates mole in a hole
func _ready():
	start_y = position.y
	target_y = start_y

# Makes the mole move smoothly to the target position
func _process(delta):
	position.y = lerp(position.y, target_y, delta * speed)
	if abs(position.y - target_y) < 0.01:
		position.y = target_y

# Sets a target position for the mole to move up, and starts a timer
func go_up():
	pop_time = Time.get_ticks_msec() / 1000.0
	target_y = start_y + pop_height
	is_up = true

# Sets a target position for the mole to move down, 
# and sends a signal to game_manager of how long it was up for
func go_down():
	var duration = (Time.get_ticks_msec() / 1000.0) - pop_time
	emit_signal("mole_down", self, duration)
	target_y = start_y
	is_up = false

# Sends an update score signal if a mole is hit and makes it go down
func on_hit():
	print("Trying to emit")
	emit_signal("update_score", self)
	print("You hit a mole")
	if is_up:
		go_down()
	# You can add points or sound here

# I a mole is up and a hammer enters it, it shows a hit animation and 
# sends it to the on_hit function
func _on_hit_area_body_entered(body: Node3D) -> void:
	if not is_up:
		return
	if body.is_in_group("hammer"):
		print("It was a hammer")
		play_hit_animation()
		on_hit()

# Shows the hit animation
func play_hit_animation():
	$HitParticles.restart()
	$HitParticles.emitting = true
