extends StaticBody2D

const ROTATION_SPEED_RANGE = 1
var rotation_speed = 0


func _ready():
	rotation_speed = rand_range(-ROTATION_SPEED_RANGE, ROTATION_SPEED_RANGE)


func _physics_process(delta):
	self.rotate(rotation_speed * delta)
